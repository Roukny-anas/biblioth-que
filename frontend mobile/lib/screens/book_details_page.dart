import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../models/loan.dart';
import '../services/category_service.dart';
import '../services/loan_service.dart';
import '../services/user_service.dart';

class BookDetailsPage extends StatefulWidget {
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Book _book;
  Category? _category;
  bool _isLoading = true;
  bool _isLoanLoading = false;
  String? _errorMessage;
  bool _hasBorrowedBook = false; // Track if the book is borrowed
  final LoanService _loanService = LoanService();
  final UserService _userService = UserService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _book = ModalRoute.of(context)!.settings.arguments as Book;
    _fetchCategory();
  }

  void _fetchCategory() async {
    try {
      final fetchedCategory = await CategoryService().getCategoryById(_book.categoryId);
      setState(() {
        _category = fetchedCategory;
        _isLoading = false;
      });
      await _checkIfBookIsBorrowed(); // Check if the book is borrowed
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkIfBookIsBorrowed() async {
    try {
      String? token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not logged in');
      }

      int userId = _extractUserIdFromToken(token);
      List<Loan> userLoans = await _loanService.getLoansByUserId(userId);

      setState(() {
        _hasBorrowedBook = userLoans.any((loan) => loan.id.bookId == _book.id);
      });
    } catch (e) {
      print('Error checking borrowed books: $e');
    }
  }

  Future<void> _createLoan() async {
    setState(() {
      _isLoanLoading = true;
    });

    try {
      String? token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not logged in');
      }

      int userId = _extractUserIdFromToken(token);

      if (_book.id == null) {
        throw Exception('Invalid book ID');
      }

      final loan = Loan(
        id: LoanId(
          userId: userId,
          bookId: _book.id!,
        ),
        user: {'id': userId},
        book: _book.toJson(),
        loanDate: DateTime.now(),
        returnDate: DateTime.now().add(const Duration(days: 14)),
        isReturned: false,
      );

      await _loanService.createLoan(loan);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book borrowed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _hasBorrowedBook = true; // Update borrowed status
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to borrow book: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoanLoading = false;
      });
    }
  }

  int _extractUserIdFromToken(String token) {
    return 1; // Placeholder user ID; replace with your logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        title: Text(_book.title),
      ),
      body: Container(
        color: const Color(0xFFF5F5DC),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: _book.photo != null && _book.photo!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                _book.photo!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.book, size: 100),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _book.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6F4E37),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _book.author ?? 'Unknown Author',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_errorMessage != null)
                      Text(
                        'Error fetching category: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    else if (_category != null)
                      Text(
                        'Category: ${_category!.name}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      )
                    else
                      const Text(
                        'Category: No category available',
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 16.0),
                    Text(
                      _book.description ?? 'No description available.',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24.0),
                    // Conditional rendering of the button
                    if (!_hasBorrowedBook) ...[
                      ElevatedButton(
                        onPressed: _isLoanLoading ? null : _createLoan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B4513), // Borrow button color
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoanLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Borrow Book',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ] else ...[
                      const Text(
                        'You have already borrowed this book.',
                        style: TextStyle(fontSize: 16, color: Color(0xFF8B4513)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
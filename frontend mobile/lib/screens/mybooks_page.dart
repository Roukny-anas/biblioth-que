import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/book_service.dart';
import '../models/book.dart';
import '../services/user_service.dart';
import '../services/loan_service.dart';
import '../models/loan.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class MyBooksPage extends StatefulWidget {
  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  int _selectedIndex = 2;
  List<Loan> _loans = []; // Changed from List<Book> to List<Loan>
  bool _isLoading = true;
  String? _errorMessage;
  
  final BookService _bookService = BookService();
  final UserService _userService = UserService();
  final LoanService _loanService = LoanService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String? _token;

  void _fetchBooks() async {
    if (_token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No token found. Please log in.';
      });
      return;
    }

    try {
      String? userIdStr = await _secureStorage.read(key: 'userId');
      int? userId = int.tryParse(userIdStr ?? '');

      if (userId != null) {
        // Fetch loans for the user and store them directly
        List<Loan> loans = await _loanService.getLoansByUserId(userId);
        
        setState(() {
          _loans = loans;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid user ID');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching books: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _retrieveToken() async {
    String? token = await _secureStorage.read(key: 'token');
    if (token != null) {
      setState(() {
        _token = token;
      });
      _fetchBooks();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No token found. Please log in.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveToken();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/category');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/myBooks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
        title: Text('My Books', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                : _loans.isEmpty
                    ? Center(child: Text('No books found', style: TextStyle(color: Colors.black)))
                    : ListView.builder(
                        itemCount: _loans.length,
                        itemBuilder: (context, index) {
                          final book = _loans[index].book;
                          final dateFormat = DateFormat('MMM dd, yyyy');
                          
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: _loans[index].photo != null && _loans[index].photo!.isNotEmpty
                                        ? Image.network(
                                            _loans[index].photo!,
                                            width: 80,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => 
                                                Icon(Icons.error, size: 80),
                                          )
                                        : Icon(Icons.book, size: 80),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book['title'] ?? 'Unknown Title',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Borrowed: ${dateFormat.format(_loans[index].loanDate)}',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Return by: ${dateFormat.format(_loans[index].returnDate)}',
                                          style: TextStyle(
                                            color: _loans[index].returnDate.isBefore(DateTime.now())
                                                ? Colors.red
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF8B4513),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 92, 78, 50),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Books',
          ),
        ],
      ),
    );
  }
}
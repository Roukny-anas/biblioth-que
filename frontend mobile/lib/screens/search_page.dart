import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/book_service.dart';
import '../models/book.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;
  String? _errorMessage;

  final BookService _bookService = BookService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _token;

  // Method to fetch books from the server
  void _fetchBooks() async {
    if (_token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No token found. Please log in.';
      });
      return;
    }

    try {
      List<Book> books = await _bookService.getAllBooks(token: _token!);
      setState(() {
        _books = books;
        _filteredBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching books: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Method to retrieve the stored token
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

  // Method to filter books based on the search query
  void _filterBooks(String query) {
    List<Book> filtered = _books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredBooks = filtered;
    });
  }

  // Method to build book card widget
  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/bookDetails',
          arguments: book,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: book.photo != null && book.photo!.isNotEmpty
                    ? Image.network(
                        book.photo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 50);
                        },
                      )
                    : Icon(Icons.book, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                book.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F4E37),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
        title: TextField(
          onChanged: _filterBooks,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search books by title...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : _filteredBooks.isEmpty
                    ? Center(
                        child: Text(
                          'No books found',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          return _buildBookCard(_filteredBooks[index]);
                        },
                      ),
      ),
    );
  }
}

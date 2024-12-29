import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/book_service.dart';
import '../models/book.dart';
import '../services/user_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Book> _books = [];
  bool _isLoading = true;
  String? _errorMessage;

  final BookService _bookService = BookService();
  final UserService _userService = UserService();
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
      List<Book> books = await _bookService.getAllBooks(token: _token!);
      setState(() {
        _books = books;
        _isLoading = false;
      });
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
      Navigator.pushReplacementNamed(context, '/category'); // Navigate to Category Page
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/myBooks');
    }
  }

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
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50),
                      )
                    : Icon(Icons.book, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                book.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37)),
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

  Widget _buildNewReleases() {
    List<Book> newReleases = _books.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Releases',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37)),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newReleases.length,
            itemBuilder: (context, index) {
              return Container(
                width: 140.0,
                margin: EdgeInsets.only(right: 16.0),
                child: _buildBookCard(newReleases[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOtherBooks() {
    List<Book> otherBooks = _books.skip(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Others',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37)),
        ),
        SizedBox(height: 8.0),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7,
          ),
          itemCount: otherBooks.length,
          itemBuilder: (context, index) {
            return _buildBookCard(otherBooks[index]);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
        title: Text('Home', style: TextStyle(color: Colors.white)),
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
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_books.isNotEmpty) _buildNewReleases(),
                        SizedBox(height: 16.0),
                        if (_books.length > 5) _buildOtherBooks(),
                      ],
                    ),
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

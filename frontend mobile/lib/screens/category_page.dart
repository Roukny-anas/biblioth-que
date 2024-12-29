import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/book_service.dart';
import '../services/category_service.dart';
import '../models/book.dart';
import '../models/category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 1;
  List<Book> _books = [];
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = true;
  String? _errorMessage;

  final BookService _bookService = BookService();
  final CategoryService _categoryService = CategoryService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String? _token;

  // Fetch categories from the API
  void _fetchCategories() async {
    try {
      List<Category> categories = await _categoryService.getAllCategories();
      setState(() {
        _categories = [
          Category(id: null, name: 'All'), // "All" category for all books
          ...categories,
        ];
        _selectedCategory = _categories.first; // Default selection to "All"
      });
      _fetchBooks();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching categories: $e';
      });
    }
  }

  // Fetch books based on the selected category
  void _fetchBooks() async {
    if (_token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No token found. Please log in.';
      });
      return;
    }

    try {
      List<Book> books;
      if (_selectedCategory?.id == null) {
        // Fetch all books if "All" category is selected
        books = await _bookService.getAllBooks(token: _token!);
      } else {
        // Fetch books by the selected category
        books = await _bookService.getCategoryBooks(_selectedCategory!.id!, token: _token!);
      }

      setState(() {
        _books = books;
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

  // Retrieve token from secure storage
  Future<void> _retrieveToken() async {
    String? token = await _secureStorage.read(key: 'token');
    if (token != null) {
      setState(() {
        _token = token;
      });
      _fetchCategories();
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

  // Build the category chip widget
  Widget _buildCategoryChip(Category category) {
    final bool isSelected = _selectedCategory?.name == category.name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.brown,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = category;
            _isLoading = true;
          });
          _fetchBooks();
        },
        backgroundColor: Colors.white,
        selectedColor: Color(0xFF8B4513),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color(0xFF8B4513),
            width: 1,
          ),
        ),
      ),
    );
  }

  // Build the categories section at the top of the page
  Widget _buildCategoriesSection() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryChip(_categories[index]);
        },
      ),
    );
  }

  // Build each book card
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
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, size: 50),
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

  // Handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/myBooks');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
        title: Text('Categories', style: TextStyle(color: Colors.white)),
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
      body: Column(
        children: [
          _buildCategoriesSection(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(_errorMessage!,
                              style: TextStyle(color: Colors.red)))
                      : _books.isEmpty
                          ? Center(
                              child: Text('No books found',
                                  style: TextStyle(color: Colors.black)))
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: _books.length,
                              itemBuilder: (context, index) {
                                return _buildBookCard(_books[index]);
                              },
                            ),
            ),
          ),
        ],
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
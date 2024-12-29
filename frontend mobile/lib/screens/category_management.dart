import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryManagementPage extends StatefulWidget {
  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _newCategoryController = TextEditingController();
  final CategoryService _categoryService = CategoryService();

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  // Method to fetch categories from the server
  void _fetchCategories() async {
    try {
      List<Category> categories = await _categoryService.getAllCategories();
      setState(() {
        _categories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching categories: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Method to delete a category
  Future<void> _deleteCategory(Category category) async {
    try {
      await _categoryService.deleteCategory(category.id!);
      _fetchCategories(); // Refresh the list after deleting
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting category: $e')),
      );
    }
  }

  // Method to show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(Category category) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Category',
            style: TextStyle(color: Color(0xFF8B4513)),
          ),
          content: Text(
            'Are you sure you want to delete "${category.name}"?',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF8B4513),
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCategory(category);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Method to create a new category
  Future<void> _createCategory(String name) async {
    try {
      final newCategory = Category(name: name);
      await _categoryService.createCategory(newCategory);
      _fetchCategories(); // Refresh the list after creating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating category: $e')),
      );
    }
  }

  // Method to show create category dialog
  Future<void> _showCreateCategoryDialog() async {
    _newCategoryController.clear();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Create New Category',
            style: TextStyle(color: Color(0xFF8B4513)),
          ),
          content: TextField(
            controller: _newCategoryController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF8B4513)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF8B4513), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF8B4513)),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF8B4513),
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newCategoryController.text.isNotEmpty) {
                  _createCategory(_newCategoryController.text);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B4513),
                foregroundColor: Color(0xFFF5F5DC),
              ),
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Method to filter categories based on the search query
  void _filterCategories(String query) {
    List<Category> filtered = _categories
        .where((category) => category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredCategories = filtered;
    });
  }

  // Method to build category card widget
  Widget _buildCategoryCard(Category category) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/categoryDetails',
            arguments: category,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6F4E37),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () => _showDeleteConfirmationDialog(category),
              ),
            ],
          ),
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
          onChanged: _filterCategories,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search categories...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCategoryDialog,
        backgroundColor: Color(0xFF8B4513),
        child: Icon(Icons.add, color: Colors.white),
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
                : _filteredCategories.isEmpty
                    ? Center(
                        child: Text(
                          'No categories found',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildCategoryCard(_filteredCategories[index]),
                          );
                        },
                      ),
      ),
    );
  }
}
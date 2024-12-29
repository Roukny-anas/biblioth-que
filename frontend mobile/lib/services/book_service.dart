import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String apiUrl = 'http://10.0.2.2:8080/api/books';
  
  // Fetch all books with authentication token
  Future<List<Book>> getAllBooks({required String token}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Request Headers for getAllBooks: $headers');
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      
      print('getAllBooks Response: ${response.statusCode}, Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> booksJson = jsonDecode(response.body);
        return booksJson.map((bookJson) => Book.fromJson(bookJson)).toList();
      } else {
        throw Exception('Failed to fetch books: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception during fetching all books: $e');
      throw Exception('Error fetching books: $e');
    }
  }

  // Fetch books by category with authentication token
  Future<List<Book>> getCategoryBooks(int categoryId, {required String token}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Request Headers for getCategoryBooks: $headers');
      
      // Construct URL with category parameter
      final categoryUrl = '$apiUrl/category/$categoryId';
      
      final response = await http.get(
        Uri.parse(categoryUrl),
        headers: headers,
      );
      
      print('getCategoryBooks Response: ${response.statusCode}, Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> booksJson = jsonDecode(response.body);
        return booksJson.map((bookJson) => Book.fromJson(bookJson)).toList();
      } else if (response.statusCode == 404) {
        // Return empty list if no books found for category
        return [];
      } else {
        throw Exception('Failed to fetch books for category: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception during fetching books by category: $e');
      throw Exception('Error fetching books for category: $e');
    }
  }

  // Search books with authentication token
  Future<List<Book>> searchBooks(String query, {required String token}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Request Headers for searchBooks: $headers');
      
      // Construct URL with search parameter
      final searchUrl = '$apiUrl/search?query=$query';
      
      final response = await http.get(
        Uri.parse(searchUrl),
        headers: headers,
      );
      
      print('searchBooks Response: ${response.statusCode}, Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> booksJson = jsonDecode(response.body);
        return booksJson.map((bookJson) => Book.fromJson(bookJson)).toList();
      } else if (response.statusCode == 404) {
        // Return empty list if no books found
        return [];
      } else {
        throw Exception('Failed to search books: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception during searching books: $e');
      throw Exception('Error searching books: $e');
    }
  }

  // Get book by ID with authentication token
  Future<Book> getBookById(int bookId, {required String token}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Request Headers for getBookById: $headers');
      
      final bookUrl = '$apiUrl/$bookId';
      
      final response = await http.get(
        Uri.parse(bookUrl),
        headers: headers,
      );
      
      print('getBookById Response: ${response.statusCode}, Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final bookJson = jsonDecode(response.body);
        return Book.fromJson(bookJson);
      } else if (response.statusCode == 404) {
        throw Exception('Book not found');
      } else {
        throw Exception('Failed to fetch book: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception during fetching book by ID: $e');
      throw Exception('Error fetching book: $e');
    }
  }
}
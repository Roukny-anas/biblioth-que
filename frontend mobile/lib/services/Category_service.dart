import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/category.dart';

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/categories';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Fetch a category by ID with authentication
  Future<Category> getCategoryById(int id) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        throw Exception('Failed to fetch category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category by ID: $e');
    }
  }

  // Fetch all categories with authentication
  Future<List<Category>> getAllCategories() async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = jsonDecode(response.body);
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Create a new category
  Future<Category> createCategory(Category category) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(category.toJson()),
      );

      if (response.statusCode == 201) {
        return Category.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Update an existing category
  Future<Category> updateCategory(int id, Category category) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: jsonEncode(category.toJson()),
      );

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        throw Exception('Failed to update category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Delete a category by ID
  Future<void> deleteCategory(int id) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  // Fetch a category by name
  Future<Category> getCategoryByName(String name) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/search/$name'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        throw Exception('Failed to fetch category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category by name: $e');
    }
  }
}
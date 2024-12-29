import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class UserService {
  static const String registerApiUrl = 'http://10.0.2.2:8080/api/auth/signup';
  static const String loginApiUrl = 'http://10.0.2.2:8080/api/auth/signin';

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Register user
  Future<String> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(registerApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      print('Register Response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        return 'User registered successfully';
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception('Failed to register user: ${errorResponse['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception during registration: $e');
      throw Exception('Error registering user');
    }
  }

  // Login user and get token and userId
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Login Response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        final int userId = responseData['userId'];

        if (token.isNotEmpty) {
          await _storage.write(key: 'token', value: token);
          await _storage.write(key: 'userId', value: userId.toString());
          return {
            'token': token,
            'userId': userId,
            'role': responseData['role'],  // Ensure role is included in the response
          };
        } else {
          throw Exception('Token not found in the response');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials. Please check your email and password.');
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception('Login failed: ${errorResponse['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception during login: $e');
      throw Exception('Error logging in: $e');
    }
  }

  // Method to retrieve the stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Method to retrieve the stored userId
  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/loan.dart';

class LoanService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/loans';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Get loan by composite ID
  Future<Loan> getLoanById(LoanId id) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/${id.userId}_${id.bookId}'),
        headers: headers,
      );

      print('Get Loan by ID Response Status: ${response.statusCode}');
      print('Get Loan by ID Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return Loan.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Loan not found');
      } else {
        throw Exception('Failed to fetch loan. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in getLoanById: $e');
      throw Exception('Error fetching loan by ID: $e');
    }
  }

  // Get all loans (Admin only)
  Future<List<Loan>> getAllLoans() async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      print('Get All Loans Response Status: ${response.statusCode}');
      print('Get All Loans Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> loansJson = jsonDecode(response.body);
        return loansJson.map((json) => Loan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load loans. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in getAllLoans: $e');
      throw Exception('Error fetching loans: $e');
    }
  }

  // Get loans by user ID
  Future<List<Loan>> getLoansByUserId(int userId) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: headers,
      );

      print('Get Loans by User ID Response Status: ${response.statusCode}');
      print('Get Loans by User ID Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> loansJson = jsonDecode(response.body);
        return loansJson.map((json) => Loan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user loans. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in getLoansByUserId: $e');
      throw Exception('Error fetching user loans: $e');
    }
  }

  // Create a new loan
  Future<Loan> createLoan(Loan loan) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(loan.toJson()),
      );

      print('Create Loan Response Status: ${response.statusCode}');
      print('Create Loan Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return Loan.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create loan. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in createLoan: $e');
      throw Exception('Error creating loan: $e');
    }
  }

// Delete a loan (Admin or User based on authorization)
Future<void> deleteLoan(LoanId id) async {
  try {
    String? token = await _secureStorage.read(key: 'token');
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/${id.userId}/${id.bookId}'), // Update URL structure
      headers: headers,
    );

    print('Delete Loan Response Status: ${response.statusCode}');

    if (response.statusCode != 204) {
      throw Exception('Failed to delete loan. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception in deleteLoan: $e');
    throw Exception('Error deleting loan: $e');
  }
}
}
// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.1.10:8080/api/auth';
  static const String _authTokenKey = 'auth_token';

  Future<void> _saveToken(String token) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    print('Token saved: ${token.substring(0, 5)}...'); // Log first 5 chars
  } catch (e) {
    print('Error saving token: $e');
    throw Exception('Failed to save authentication token');
  }
}

Future<String?> getToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    print('Retrieved token: ${token != null ? token.substring(0, 5) + '...' : 'null'}');
    return token;
  } catch (e) {
    print('Error getting token: $e');
    return null;
  }
}

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim(), 'password': password.trim()}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveToken(responseData['token']);
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Failed to connect to server');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      print('Token removed successfully'); 
    } catch (e) {
      print('Logout error: $e');
      throw Exception('Failed to clear session data');
    }
  }
Future<Map<String, dynamic>> signup({
  required String email,
  required String password,
  required String username,
  required String role,
}) async {
  try {
    final url = Uri.parse('$_baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password.trim(),
        'username': username.trim(),
        'role': role.trim(),
      }),
    );

    // First try to parse as JSON
    try {
      final responseData = jsonDecode(response.body);
      debugPrint('Signup JSON response: $responseData');
      
      if (response.statusCode == 200) {
        if (responseData['token'] != null) {
          await _saveToken(responseData['token']);
          return responseData;
        } else {
          // If no token but successful, proceed to login
          debugPrint('No token in response, attempting login...');
          return await login(email: email, password: password);
        }
      } else {
        throw Exception(responseData['message'] ?? 'Signup failed');
      }
    } on FormatException {
      // Handle plain text response
      debugPrint('Plain text response: ${response.body}');
      if (response.statusCode == 200 && 
          response.body.contains('User registered successfully')) {
        // Proceed to login since signup was successful
        return await login(email: email, password: password);
      } else {
        throw Exception(response.body);
      }
    }
  } catch (e) {
    debugPrint('Signup error: $e');
    throw Exception('Failed to complete signup: $e');
  }
}
}

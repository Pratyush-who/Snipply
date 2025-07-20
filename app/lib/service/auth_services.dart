// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.1.10:8080/api/auth';
  static const String _authTokenKey = 'auth_token';

  Future<void> _saveToken(String token) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    print('Token saved successfully'); // Debug log
  } catch (e) {
    print('Error saving token: $e');
    throw Exception('Failed to save authentication token');
  }
}

Future<String?> getToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    print('Retrieved token: ${token != null ? "[exists]" : "null"}'); // Debug
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
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
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
    print('Token removed successfully'); // Debug log
    
    // Optional: Add API call to invalidate token on server if needed
    // final token = await getToken();
    // if (token != null) {
    //   await http.post(
    //     Uri.parse('$_baseUrl/logout'),
    //     headers: {'Authorization': 'Bearer $token'},
    //   );
    // }
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

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        await _saveToken(responseData['token']);
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception('Failed to connect to server');
    }
  }
}
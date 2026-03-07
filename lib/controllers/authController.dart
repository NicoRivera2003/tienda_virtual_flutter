import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  static User? _currentUser;
  static int? _userId;
  static String? _userEmail;
  static const String _baseUrl = 'http://192.168.0.12:5248';

  static Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/Auth/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _currentUser = User(username: body['name'] ?? email, password: '');
        _userId = body['userId'];
        _userEmail = email.trim().toLowerCase();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static User? get currentUser => _currentUser;
  static int? get userId => _userId;
  static String? get userEmail => _userEmail;

  static void logout() {
    _currentUser = null;
    _userId = null;
    _userEmail = null;
  }

  static String get username {
    if (_currentUser != null && _currentUser!.username.isNotEmpty) {
      return _currentUser!.username;
    } else {
      return "usuario";
    }
  }
}

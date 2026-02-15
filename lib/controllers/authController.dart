import '../models/user.dart';

class AuthController {
  static User? _currentUser;

  static bool login(String username, String password) {
    if (username.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(username: username, password: password);
      return true;
    }
    return false;
  }

  static User? get currentUser => _currentUser;

  static void logout() {
    _currentUser = null;
  }

  static String get username {
    if (_currentUser != null && _currentUser!.username.isNotEmpty) {
      return _currentUser!.username;
    } else {
      return "usuario";
    }
  }
}

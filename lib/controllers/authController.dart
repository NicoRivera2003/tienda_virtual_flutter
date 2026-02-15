import '../models/user.dart';

class AuthController {
  static User? _currentUser;

  static bool login(String username, String password) {
    // Usuario fijo por ahora
    if (username == "admin" && password == "1234") {
      _currentUser = User(username: username, password: password);
      String user = username;

      return true;
    }
    return false;
  }

  static User? get currentUser => _currentUser;

  static void logout() {
    _currentUser = null;
  }

  static String get username {
    return _currentUser?.username ?? "usuario";
  }
}

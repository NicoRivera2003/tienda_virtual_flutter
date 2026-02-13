import "../data/repository.dart";

class Authcontroller {
  final Repository _repository = Repository();

  bool autenticate(String email, String password) {
    return _repository.login(email, password);
  }
}

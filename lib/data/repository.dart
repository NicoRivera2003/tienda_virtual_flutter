import '../models/product.dart';
import 'fake_data.dart';

class Repository {
  List<Product> getProducts() {
    return FakeData.products;
  }

  Product? getProductById(int id) {
    return FakeData.products.firstWhere((product) => product.id == id);
  }

  bool login(String username, String password) {
    return username == "admin" && password == "1234";
  }
}

import '../data/repository.dart';
import '../models/product.dart';

class ProductController {
  final Repository _repository = Repository();

  List<Product> fetchProducts() {
    return _repository.getProducts();
  }
}

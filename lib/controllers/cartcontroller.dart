import '../models/product.dart';
import '../models/cart.dart';

class CartController {
  static final CartController _instance = CartController._internal();

  factory CartController() {
    return _instance;
  }

  CartController._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    try {
      CartItem existingItem = _items.firstWhere(
        (item) => item.product.name == product.name,
      );

      existingItem.quantity++;
    } catch (e) {
      _items.add(CartItem(product: product));
    }
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
  }

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  void clearCart() {
    _items.clear();
  }
}

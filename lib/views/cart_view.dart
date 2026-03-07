import 'package:flutter/material.dart';
import '../controllers/cartcontroller.dart';
import '../models/cart.dart';
import '../widgets/bottom_nav_bar.dart';
import 'checkout_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController _cartController = CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),

      appBar: AppBar(
        backgroundColor: const Color(0xFFD8CFC3),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "TU CARRITO",
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: _cartController.items.isEmpty
          ? const Center(child: Text("Tu carrito está vacío"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartController.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = _cartController.items[index];
                        return _buildCartItem(cartItem);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Subtotal y envío
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("SUBTOTAL",
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      Text("\$${_cartController.subtotal.toStringAsFixed(2)}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ENVÍO", style: TextStyle(fontWeight: FontWeight.w900)),
                      Text("CORTESÍA"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  //Total y botón finalizar
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("TOTAL",
                                style: TextStyle(
                                  color: Color(0xFFD8CFC3),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              "\$${_cartController.subtotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Color(0xFFD8CFC3),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD8CFC3),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CheckoutView()),
                              );
                            },
                            child: const Text(
                              "FINALIZAR COMPRA",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCartItem(CartItem item) {
  return Stack(
    children: [
      Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12, top: 8, right: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.network(item.product.image,
                  width: 60, height: 60, fit: BoxFit.cover),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("\$${item.product.price}",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () => setState(
                        () => _cartController.decreaseQuantity(item)),
                  ),
                  Text(item.quantity.toString()),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () => setState(
                        () => _cartController.increaseQuantity(item)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            _cartController.removeItem(item);
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 14),
          ),
        ),
      ),
    ],
  );
}
}
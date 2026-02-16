import 'package:flutter/material.dart';
import '../controllers/cartcontroller.dart';
import '../models/product.dart';
import '../models/cart.dart';

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
        title: const Text(
          "TU CARRITO",
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ), //comment

      body: _cartController.items.isEmpty
          ? const Center(child: Text("Tu carrito está vacío"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// LISTA
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

                  /// SUBTOTAL Y ENVÍO (SIN TOTAL)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SUBTOTAL",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text("\$${_cartController.subtotal.toStringAsFixed(2)}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ENVÍO",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text("CORTESÍA"),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

      // TOTAL Y FINALIZAR COMPRA
      bottomNavigationBar: _cartController.items.isEmpty
          ? null
          : Container(
              color: Colors.black,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TOTAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOTAL",
                        style: TextStyle(
                          color: Color(0xFFD8CFC3),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

                  /// BOTÓN BEIGE
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
                      onPressed: () {},
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
    );
  }

  // Función que recibe el producto seleccionado y lo muestra en targeta
  Widget _buildCartItem(CartItem item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(
              item.product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name),
                  const SizedBox(height: 4),
                  Text("\$${item.product.price}"),
                ],
              ),
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _cartController.decreaseQuantity(item);
                    });
                  },
                ),

                Text(item.quantity.toString()),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _cartController.increaseQuantity(item);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "SUBTOTAL",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),

            Text("\$${_cartController.subtotal.toStringAsFixed(2)}"),
          ],
        ),

        const SizedBox(height: 10),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("ENVÍO", style: TextStyle(fontWeight: FontWeight.w900)),
            Text("CORTESÍA"),
          ],
        ),

        const Divider(height: 30),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFD8CFC3),
                ),
              ),
              Text(
                "\$${_cartController.subtotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFD8CFC3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

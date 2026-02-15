import 'package:flutter/material.dart';
import '../controllers/cartcontroller.dart';
import '../models/product.dart';

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
      ),

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
                        Product product = _cartController.items[index];

                        return _buildCartItem(product);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// RESUMEN
                  _buildSummary(),

                  const SizedBox(height: 20),

                  /// BOTÓN FINALIZAR
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "FINALIZAR COMPRA",
                        style: TextStyle(letterSpacing: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

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
            const Text("SUBTOTAL"),
            Text("\$${_cartController.subtotal.toStringAsFixed(2)}"),
          ],
        ),

        const SizedBox(height: 10),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("ENVÍO"), Text("CORTESÍA")],
        ),

        const Divider(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "\$${_cartController.subtotal.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}

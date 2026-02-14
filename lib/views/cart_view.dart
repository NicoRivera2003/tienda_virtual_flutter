import 'package:flutter/material.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 14, 12),
        centerTitle: true,
        title: const Text(
          "CARRITO",
          style: TextStyle(color: Color(0xFFD8C3C3)),
        ),
      ),

      body: const Center(
        child: Text("Tu carrito está vacío", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

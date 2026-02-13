import 'package:flutter/material.dart';
import "login_view.dart";

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 14, 12),

        centerTitle: true,
        title: const Text(
          "CATÁLOGO",
          style: TextStyle(color: Color(0xFFD8CFC3)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            Center(
              child: const Text(
                "BIENVENIDO AL CATÁLOGO",
                style: TextStyle(fontSize: 22),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/authController.dart';
import '../widgets/bottom_nav_bar.dart';
import 'login_view.dart';
import 'my_orders_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 14, 12),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("PERFIL", style: TextStyle(color: Color(0xFFD8CFC3))),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: Colors.black),
            ),

            const SizedBox(height: 30),

            Text(
              AuthController.username.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Serif',
              ),
            ),

            const SizedBox(height: 10),

            Text(
              AuthController.userEmail ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            //Mis pedidos
            Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text("Mis pedidos",
                    style: TextStyle(fontFamily: 'Serif')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MyOrdersView())),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                AuthController.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              },
              child: const Text("Cerrar sesión",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
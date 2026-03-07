import 'package:flutter/material.dart';
import 'package:tienda_virtual/controllers/cartcontroller.dart';
import '../views/catalog_view.dart';
import '../views/cart_view.dart';
import '../views/profile_view.dart';
import '../views/my_orders_view.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    final destinations = [
      const CatalogView(),
      const CartView(),
      const MyOrdersView(),
      const ProfileView(),
    ];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destinations[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = CartController().items.length;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            backgroundColor: Colors.red,
            label: Text(cartCount.toString(),
            style: const TextStyle(fontSize: 10, color: Colors.white)
            ),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          activeIcon: Badge(
            isLabelVisible: cartCount > 0,
            backgroundColor: Colors.red,
            label: Text(cartCount.toString(),
                style: const TextStyle(fontSize: 10, color: Colors.white)),
            child: const Icon(Icons.shopping_cart),
          ),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Mis pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
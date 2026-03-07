import 'package:flutter/material.dart';
import 'login_view.dart';
import '../models/product.dart';
import 'product_detail_view.dart';
import 'cart_view.dart';
import 'profile_view.dart';
import '../services/product_service.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  int? _pressedIndex;
  /* final ProductController _controller = ProductController(); */
  final TextEditingController _searchController = TextEditingController();
  final ProductService _service = ProductService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await _service.fetchProducts();

    print(products);

    setState(() {
      _allProducts = products;
      _filteredProducts = _allProducts;
    });
  }

  // Filtro de productos
  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

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
            icon: const Icon(Icons.logout, color: Colors.white),
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
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Text(
                "BIENVENIDO AL CATÁLOGO",
                style: TextStyle(fontSize: 22),
              ),
            ),

            const SizedBox(height: 20),

            // Filtro de productos
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: _filterProducts,
            ),

            const SizedBox(height: 20),

            // Lista de targetas
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 productos por fila
                  crossAxisSpacing: 10, // Espacio horizontal entre cards
                  mainAxisSpacing: 10, // Espacio vertical entre cards
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  List<String> priceParts = product.price.toString().split(".");

                  return GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _pressedIndex = index;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _pressedIndex = null;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _pressedIndex = null;
                      });
                    },
                    onTap: () async {
                      setState(() {
                        _pressedIndex = index;
                      });

                      await Future.delayed(const Duration(milliseconds: 180));

                      setState(() {
                        _pressedIndex = null;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailView(product: product),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      child: Card(
                        elevation: _pressedIndex == index ? 8 : 0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: const Color(0xFFF5F5F5),
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Serif',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "\$${priceParts[0]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Menú inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Mantiene los iconos fijos
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CatalogView()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartView()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileView()),
            );
          }
        },
      ),
    );
  }
}

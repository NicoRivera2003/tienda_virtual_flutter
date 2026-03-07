import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_view.dart';
import '../models/product.dart';
import 'product_detail_view.dart';
import 'cart_view.dart';
import 'profile_view.dart';
import '../services/product_service.dart';
import '../widgets/bottom_nav_bar.dart';

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
  String _selectedCategory = 'Todos';

  static const String _whatsappNumber = '573043052568';

  final List<String> _categories = [
    'Todos',
    'Trajes',
    'Calzado',
    'Accesorios',
    'Camisetas',
    'Pantalones',
  ];

  final Map<String, List<String>> _categoryKeywords  = {
    'Trajes':     ['traje', 'smoking', 'tuxedo', 'blazer', 'saco'],
    'Calzado':    ['zapato', 'zapatilla', 'mocasin', 'bota', 'sandalia', 'calzado'],
    'Accesorios': ['reloj', 'cinturon', 'corbata', 'bufanda', 'accesorio', 'bolso'],
    'Camisetas':  ['camiseta', 'camisa', 'polo', 'remera', 'playera'],
    'Pantalones': ['pantalon', 'jean', 'bermuda', 'short', 'jogger'],
  };

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await _service.fetchProducts();

    /* print(products); */

    setState(() {
      _allProducts = products;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

        final matchesCategory = _selectedCategory == 'Todos' ||
          (_categoryKeywords[_selectedCategory] ?? []).any(
            (keyword) =>  product.name.toLowerCase().contains(keyword) ||
                          product.description.toLowerCase().contains(keyword),
          );
          return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      '¡Hola! Estoy interesado en un producto de su catálogo. ¿Me pueden ayudar?'
    );
    final url = Uri.parse('https://wa.me/$_whatsappNumber?text=$message');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo abrir WhatsApp.")),
        );
      }
    }
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

      floatingActionButton: FloatingActionButton(
        onPressed: _openWhatsApp,
        backgroundColor: const Color(0xFF25D366),
        tooltip: 'Contactar por WhatsApp',
        child: Image.asset(
          'assets/images/whatsapp.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
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
              onChanged: (_) => _applyFilters(),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = category);
                      _applyFilters();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade400,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? const Color(0xFFD8CFC3) : Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Lista de targetas
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        "No se encontraron productos.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _filteredProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        final priceParts = product.price.toString().split(".");

                        return GestureDetector(
                          onTapDown: (_) => setState(() => _pressedIndex = index),
                          onTapUp: (_) => setState(() => _pressedIndex = null),
                          onTapCancel: () => setState(() => _pressedIndex = null),
                          onTap: () async {
                            setState(() => _pressedIndex = index);
                            await Future.delayed(const Duration(milliseconds: 180));
                            setState(() => _pressedIndex = null);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailView(product: product),
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
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0,
      ),
    );
  }
}

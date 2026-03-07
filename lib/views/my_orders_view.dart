import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../controllers/authController.dart';
import '../widgets/bottom_nav_bar.dart';
import 'order_status_view.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  static const String _baseUrl = 'http://192.168.0.12:5248';
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final userId = AuthController.userId ?? 0;
      final response = await http.get(
        Uri.parse('$_baseUrl/api/Order/GetUserOrders/$userId'), //PETICIÓN GET PARA OBTENER LAS COMPRAS DEL USUARIO EN SESIÓN
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        setState(() => _orders = body['orders']);
      } else {
        setState(() => _error = "Error al cargar los pedidos.");
      }
    } catch (e) {
      setState(() => _error = "No se pudo conectar al servidor.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Entregado':   return Colors.green;
      case 'En camino':   return Colors.blue;
      default:            return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Entregado':   return Icons.check_circle_outline;
      case 'En camino':   return Icons.local_shipping_outlined;
      default:            return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 14, 12),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("MIS PEDIDOS",
            style: TextStyle(color: Color(0xFFD8CFC3), letterSpacing: 2)),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _error != null
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchOrders,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("Reintentar",
                          style: TextStyle(color: Color(0xFFD8CFC3))),
                    ),
                  ],
                ))
              : _orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 64, color: Colors.black26),
                          const SizedBox(height: 16),
                          const Text("Aún no tienes pedidos.",
                              style: TextStyle(fontSize: 16, color: Colors.black54)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchOrders,
                      color: Colors.black,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          final status = order['status'] ?? '';
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderStatusView(
                                      orderId: order['idRows']),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    width: 44, height: 44,
                                    decoration: BoxDecoration(
                                      color: _statusColor(status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(_statusIcon(status),
                                        color: _statusColor(status), size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pedido #${order['idRows']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: _statusColor(status).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: _statusColor(status),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "\$${(order['total'] as num).toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                  color: Colors.grey, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
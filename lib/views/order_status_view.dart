import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav_bar.dart';

class OrderStatusView extends StatefulWidget {
  final int orderId;
  const OrderStatusView({super.key, required this.orderId});

  @override
  State<OrderStatusView> createState() => _OrderStatusViewState();
}

class _OrderStatusViewState extends State<OrderStatusView> {
  static const String _baseUrl = 'http://192.168.0.12:5248';

  Map<String, dynamic>? _order;
  bool _isLoading = true;
  String? _error;

  final List<String> _steps = ['En preparación', 'En camino', 'Entregado'];

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/Order/GetOrderStatus/${widget.orderId}'), //PETICIÓN GET PARA OBTENER EL ESTADO DE LAS ORDENES DE COMPRA
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        setState(() => _order = body);
      } else {
        setState(() => _error = body['message'] ?? "Error al cargar el pedido.");
      }
    } catch (e) {
      setState(() => _error = "No se pudo conectar al servidor.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  int get _currentStep {
    final status = _order?['status'] ?? '';
    print('STATUS RECIBIDO: "$status"');
    return _steps.indexOf(status).clamp(0, _steps.length - 1);
  }

  IconData _iconForStep(int index) {
    switch (index) {
      case 0: return Icons.inventory_2_outlined;
      case 1: return Icons.local_shipping_outlined;
      case 2: return Icons.check_circle_outline;
      default: return Icons.circle_outlined;
    }
  }

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
          "ESTADO DEL PEDIDO",
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
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
                      onPressed: _fetchOrder,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("Reintentar", style: TextStyle(color: Color(0xFFD8CFC3))),
                    ),
                  ],
                ))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("PEDIDO CONFIRMADO ✓",
                                style: TextStyle(color: Color(0xFFD8CFC3),
                                    fontWeight: FontWeight.w900, letterSpacing: 2)),
                            const SizedBox(height: 6),
                            Text("Pedido #${_order!['orderId']}",
                                style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            Text("Revisa tu correo para ver la confirmación.",
                                style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text("ESTADO ACTUAL",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Row(
                          children: List.generate(_steps.length, (index) {
                            final isDone = index <= _currentStep;
                            final isLast = index == _steps.length - 1;
                            return Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 50, height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isDone ? Colors.black : Colors.grey.shade200,
                                          ),
                                          child: Icon(_iconForStep(index),
                                              color: isDone ? const Color(0xFFD8CFC3) : Colors.grey,
                                              size: 22),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(_steps[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: isDone ? FontWeight.w700 : FontWeight.w400,
                                              color: isDone ? Colors.black : Colors.grey,
                                            )),
                                      ],
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        margin: const EdgeInsets.only(bottom: 28),
                                        color: index < _currentStep ? Colors.black : Colors.grey.shade300,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text("DETALLE DEL PEDIDO",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      const SizedBox(height: 12),

                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ...(_order!['items'] as List).map((item) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['productName'],
                                            style: const TextStyle(fontWeight: FontWeight.w500)),
                                        Text("Cantidad: ${item['quantity']}",
                                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Text("\$${(item['subtotal'] as num).toStringAsFixed(0)}",
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            )),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("TOTAL",
                                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                                  Text("\$${(_order!['total'] as num).toStringAsFixed(0)}",
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          children: [
                            const Icon(Icons.payment_outlined, size: 22),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("MÉTODO DE PAGO",
                                    style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 1)),
                                Text(_order!['paymentMethod'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            print('BOTON PRESIONADO');
                            _fetchOrder();
                          },
                          icon: const Icon(Icons.refresh, color: Colors.black),
                          label: const Text("ACTUALIZAR ESTADO",
                              style: TextStyle(color: Colors.black, letterSpacing: 1)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      
                    ],
                  ),
                ),
                bottomNavigationBar: const BottomNavBar(currentIndex: 2)
    );
  }
}
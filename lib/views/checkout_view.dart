import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../controllers/authController.dart';
import '../controllers/cartcontroller.dart';
import 'order_status_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final CartController _cartController = CartController();
  String _selectedPayment = 'Contra entrega';
  bool _isLoading = false;

  static const String _baseUrl = 'http://192.168.0.12:5248';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'label': 'Contra entrega',
      'icon': Icons.delivery_dining_outlined,
      'description': 'Paga cuando recibas tu pedido',
    },
    {
      'label': 'Pago digital',
      'icon': Icons.phone_android_outlined,
      'description': 'Nequi, Daviplata o transferencia',
    },
  ];

  Future<void> _confirmOrder() async {
    setState(() => _isLoading = true);
    try {
      final user = AuthController.currentUser;
      final items = _cartController.items.map((item) => {
        'productName':  item.product.name,
        'productPrice': item.product.price,
        'quantity':     item.quantity,
        'subtotal':     item.total,
      }).toList();

      final response = await http.post(
        Uri.parse('$_baseUrl/api/Order/CreateOrder'), //PETICIÓN PARA CREAR UNA NUEVA COMPRA ENVIANDO LOS DATOS CORRESPONDIENTES A LA COMPRA
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId':        AuthController.userId ?? 0,
          'userEmail':     AuthController.userEmail ?? '',
          'paymentMethod': _selectedPayment,
          'total':         _cartController.subtotal,
          'items':         items,
        }),
      );

      /* print('USER EMAIL: ${AuthController.userEmail}');
      print('USER ID: ${AuthController.userId}'); */

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        _cartController.clearCart();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderStatusView(orderId: body['orderId']),
            ),
          );
        }
      } else {
        _showSnack(body['message'] ?? "Error al crear el pedido.");
      }
    } catch (e) {
      print('ERROR CHECKOUT: $e');
      _showSnack("No se pudo conectar al servidor.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8CFC3),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "CONFIRMAR PEDIDO",
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("RESUMEN DEL PEDIDO",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  ..._cartController.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Image.network(item.product.image,
                            width: 50, height: 50, fit: BoxFit.cover),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name,
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text("Cantidad: ${item.quantity}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                        Text("\$${item.total.toStringAsFixed(0)}",
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
                        Text("\$${_cartController.subtotal.toStringAsFixed(0)}",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //Método de pago
            const Text("MÉTODO DE PAGO",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 12),

            ..._paymentMethods.map((method) {
              final isSelected = _selectedPayment == method['label'];
              return GestureDetector(
                onTap: () => setState(() => _selectedPayment = method['label']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(method['icon'] as IconData,
                          color: isSelected ? const Color(0xFFD8CFC3) : Colors.black, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(method['label'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? const Color(0xFFD8CFC3) : Colors.black,
                                )),
                            Text(method['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? const Color(0xFFD8CFC3).withOpacity(0.8) : Colors.grey,
                                )),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Color(0xFFD8CFC3), size: 22),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8CFC3),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            ),
            onPressed: _isLoading ? null : _confirmOrder,
            child: _isLoading
                ? const SizedBox(height: 22, width: 22,
                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
                : const Text("CONFIRMAR PEDIDO",
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
        ),
      ),
    );
  }
}
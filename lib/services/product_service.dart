import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = "http://192.168.0.12:5248 /api/Products/GetProducts";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    /* print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}"); */

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Error cargando productos");
    }
  }
}

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.43.134:8000/api';

  Future<List<dynamic>> getAnimals() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.134:8000/api/animals'),
    );
    print('respons staut: ${response.statusCode}');
    print('respons body: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load animals');
    }
  }

  Future<void> addAnimal(Map<String, dynamic> animalData) async {
    final response = await http.post(
      Uri.parse('http://192.168.43.134:8000/api/animal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(animalData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add animal');
    }
  }

  Future<List<dynamic>> getproduct() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.134:8000/api/product'),
    );
    print('re st ${response.statusCode}');
    print('re bo ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('filddddddddd');
    }
  }

  Future<List<dynamic>> getdoctor() async {
    final response = await http.get(Uri.parse('$baseUrl/vet'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'fillld  doctor ---------------------------------------------------------------',
      );
    }
  }

  getCartItems() {}

  getCart() {}
}

Future<void> addToCart(int productId, int quantity) async {
  final url = Uri.parse('http://192.168.43.134:8000/api/add-cart');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'product_id': productId, 'quantity': quantity}),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Added to cart: ${responseData['cart_item']}');
    } else {
      print('Failed to add to cart: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<List> cart() async {
  final response = await http.get(
    Uri.parse('http://192.168.43.134:8000/api/cart'),
  );
  if (response.statusCode == 200) {
    print('Cart data: ${response.body}');
    List<dynamic> cartItems = jsonDecode(response.body);

    // فك التغليف إذا كانت البيانات داخل مصفوفة إضافية
    if (cartItems.isNotEmpty && cartItems[0] is List) {
      cartItems = cartItems[0];
    }

    return cartItems;
  } else {
    print('Error: ${response.statusCode}');
    throw Exception('Failed to load cart data');
  }
}

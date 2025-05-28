// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.43.134:8000/api';

  // جلب قائمة الحيوانات
  Future<List<dynamic>> getAnimals() async {
    final response = await http.get(Uri.parse('$baseUrl/animals'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load animals');
    }
  }

  // إضافة حيوان جديد
  Future<void> addAnimal(Map<String, dynamic> animalData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(animalData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add animal');
    }
  }

  // جلب المنتجات
  Future<List<dynamic>> getProduct() async {
    final response = await http.get(Uri.parse('$baseUrl/product'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // جلب الأطباء البيطريين
  Future<List<dynamic>> getDoctor() async {
    final response = await http.get(Uri.parse('$baseUrl/vet'));
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  // دوال مهيأة للشراء (تحتاج تنفيذ)
  getCartItems() {}

  getCart() {}
}

// إضافة منتج إلى السلة
Future<void> addToCart(int productId, int quantity) async {
  const baseUrl = 'http://192.168.43.134:8000/api';
  final url = Uri.parse('$baseUrl/add-cart');

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

// جلب محتويات السلة
Future<List> cart() async {
  const baseUrl = 'http://192.168.43.134:8000/api';
  final response = await http.get(Uri.parse('$baseUrl/cart'));

  if (response.statusCode == 200) {
    print('Cart data: ${response.body}');
    List<dynamic> cartItems = jsonDecode(response.body);

    // إذا البيانات مغلفة بمصفوفة إضافية
    if (cartItems.isNotEmpty && cartItems[0] is List) {
      cartItems = cartItems[0];
    }

    return cartItems;
  } else {
    print('Error: ${response.statusCode}');
    throw Exception('Failed to load cart data');
  }
}

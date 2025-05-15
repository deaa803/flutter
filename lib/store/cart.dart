// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetlink1/store/api_service.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List cartItems = [];
  bool isloding = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final data = await cart();
      setState(() {
        cartItems = data;
        isloding = false;
      });
    } catch (e) {
      print('Error fetching cart: $e');
      setState(() {
        isloding = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load cart items')));
    }
  }

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) =>
          sum +
          (double.parse(item['product']['price'].toString()) *
              item['quantity']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart'), backgroundColor: Colors.yellow),
      body:
          isloding
              ? Center(child: SpinKitWave(color: Colors.yellow, size: 50.0))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Image.asset(
                                'assest/images/2.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text('${item['product']['name']}'),
                              subtitle: Text(
                                'Price: \$${item['product']['price']}',
                              ),
                              trailing: Text('x${item['quantity']}'),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${totalPrice.toStringAsFixed(2)} ل.س',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Purchase completed successfully'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Buy', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
    );
  }
}

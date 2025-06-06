// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vetlink1/store/api_service.dart';

class Details extends StatefulWidget {
  final int id_product;
  final int price_product;
  final String name_product;
  final String desc;

  const Details({
    super.key,
    required this.id_product,
    required this.price_product,
    required this.name_product,
    required this.desc,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // الحصول على الثيم الحالي

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/picture/logo vetlink crop2.png", width: 50),
            const Text(" vet", style: TextStyle(color: Colors.white)),
            const Text("link", style: TextStyle(color: Colors.yellow)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/picture/logo vetlink crop2.png",
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.name_product,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary, // لون الاسم متوافق مع الثيم
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.desc,
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.price_product} ل.س',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الكمية:', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: Icon(Icons.remove, color: theme.iconTheme.color),
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: Icon(Icons.add, color: theme.iconTheme.color),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addToCart(widget.id_product, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة المنتج إلى السلة')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'أضف إلى السلة',
                  style: TextStyle(fontSize: 18, color: theme.iconTheme.color),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "منتجات مقترحة",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSuggestedProduct("assets/picture/1.png", "منتج 1"),
                  _buildSuggestedProduct("assets/picture/1.png", "منتج 2"),
                  _buildSuggestedProduct("assets/picture/1.png", "منتج 3"),
                  _buildSuggestedProduct("assets/picture/1.png", "منتج 4"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedProduct(String imagePath, String productName) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Image.asset(imagePath, width: 100, height: 100),
          const SizedBox(height: 5),
          Text(
            productName,
            style: TextStyle(fontSize: 14, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

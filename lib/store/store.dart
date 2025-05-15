// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vetlink1/store/api_service.dart';
import 'package:vetlink1/store/cart.dart';
import 'package:vetlink1/store/diatels.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  int activeindex = 0;
  final List<String> imagepath = ['assest/images/4.jpg', 'assest/images/3.jpg'];
  final ApiService apiService = ApiService();
  List product = [];

  @override
  void initState() {
    super.initState();
    fetchproduct();
  }

  Future<void> fetchproduct() async {
    try {
      final data = await apiService.getproduct();
      print('product : $data');
      setState(() {
        product = data;
      });
    } catch (e) {
      print('$e ---------------------------------------------------------');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load product'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // الحصول على الثيم الحالي

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: fetchproduct,
        child:
            product.isEmpty
                ? Center(
                  child: Lottie.asset(
                    'assest/picture/1.json',
                    width: 100,
                    height: 100,
                  ),
                )
                : Column(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: CarouselSlider.builder(
                        itemCount: imagepath.length,
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imagepath[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 4),
                          autoPlayAnimationDuration: Duration(
                            microseconds: 800,
                          ),
                          autoPlayCurve: Curves.easeInOut,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeindex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    AnimatedSmoothIndicator(
                      activeIndex: activeindex,
                      count: imagepath.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: theme.colorScheme.secondary,
                        dotHeight: 8,
                        dotWidth: 8,
                        dotColor: theme.disabledColor,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.length,
                        itemBuilder: (context, i) {
                          return Container(
                            width: 150,
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: theme.cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    "assest/picture/1.png",
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  product[i]["name"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  product[i]['price'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: product.length,
                        itemBuilder: (context, index) {
                          final item = product[index];
                          return Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    "assest/picture/1.png",
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        '\$${item['price']}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return Details(
                                                  id_product: item['id'],
                                                  price_product: 3000,
                                                  name_product:
                                                      '${item['name']}',
                                                  desc: '',
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                            color: theme.iconTheme.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart()),
          );
        },
        backgroundColor: theme.colorScheme.secondary,
        child: Icon(Icons.shopping_cart, color: theme.iconTheme.color),
      ),
    );
  }
}

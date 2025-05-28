// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  final List<String> imagepath = ['assets/images/4.jpg', 'assets/images/3.jpg'];
  final ApiService apiService = ApiService();
  List product = [];

  @override
  void initState() {
    super.initState();
    fetchproduct();
  }

  Future<void> fetchproduct() async {
    try {
      final data = await apiService.getProduct();
      setState(() {
        product = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('فشل تحميل المنتجات'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: fetchproduct,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CarouselSlider.builder(
                      itemCount: imagepath.length,
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
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
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        autoPlayCurve: Curves.easeInOut,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeindex = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
                    if (product.isEmpty)
                      Lottie.asset(
                        'assets/picture/1.json',
                        width: 100,
                        height: 100,
                      )
                    else
                      SizedBox(
                        height: 210,
                        child: AnimationLimiter(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.length,
                            itemBuilder: (context, i) {
                              final item = product[i];
                              return AnimationConfiguration.staggeredList(
                                position: i,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => Details(
                                                  id_product: item['id'],
                                                  price_product:
                                                      int.tryParse(
                                                        item['price']
                                                            .toString(),
                                                      ) ??
                                                      0,
                                                  name_product:
                                                      '${item['name']}',
                                                  desc: '',
                                                ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 150,
                                        margin: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          color: theme.cardColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.shadowColor
                                                  .withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.asset(
                                                "assets/picture/1.png",
                                                height: 100,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              item["name"],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Tajawal',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '${item['price']} ل.س',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (product.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = product[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Details(
                                          id_product: item['id'],
                                          price_product:
                                              int.tryParse(
                                                item['price'].toString(),
                                              ) ??
                                              0,
                                          name_product: '${item['name']}',
                                          desc: '',
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio:
                                          3 /
                                          2, // أو جرب 4/3 أو 16/9 حسب الصورة
                                      child: Image.asset(
                                        "assets/picture/1.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Tajawal',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            '${item['price']} ل.س',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color:
                                                  theme.colorScheme.secondary,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Tajawal',
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),

                                          TextButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => Details(
                                                        id_product: item['id'],
                                                        price_product:
                                                            int.tryParse(
                                                              item['price']
                                                                  .toString(),
                                                            ) ??
                                                            0,
                                                        name_product:
                                                            '${item['name']}',
                                                        desc: '',
                                                      ),
                                                ),
                                              );
                                            },

                                            label: Text(
                                              'اضف الى السلة ',
                                              style: TextStyle(
                                                color: theme.iconTheme.color,
                                                fontFamily: 'tajawal',
                                                fontSize: 13,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.shopping_cart,
                                              color: theme.iconTheme.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: product.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 115)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Cart()),
          );
        },
        backgroundColor: theme.colorScheme.secondary,
        child: Icon(Icons.shopping_cart, color: theme.iconTheme.color),
      ),
    );
  }
}

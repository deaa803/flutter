// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vetlink1/store/show_dialogg.dart';
import 'api_service.dart';
import 'package:lottie/lottie.dart';

class Animal extends StatefulWidget {
  const Animal({super.key});

  @override
  State<Animal> createState() => _AnimalState();
}

class _AnimalState extends State<Animal> {
  final ApiService apiService = ApiService();
  List animal = [];

  @override
  void initState() {
    super.initState();
    fetchAnimal();
  }

  Future<void> fetchAnimal() async {
    try {
      await Future.delayed(Duration(seconds: 5));
      final data = await apiService.getAnimals();
      setState(() {
        animal = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchAnimal,
        child:
            animal.isEmpty
                ? Center(
                  child: Lottie.asset(
                    'assest/picture/4.json',
                    width: 500,
                    height: 500,
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: animal.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: Column(
                          children: [
                            Image.asset(
                              "assest/images/6.jpg",
                              height: 250,
                              width: 250,
                            ),
                            Text('name: ${animal[i]["name"]}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final newAnimal = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShowDialogg()),
          );

          if (newAnimal != null) {
            await fetchAnimal();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة الحيوان بنجاح!')),
            );
          }
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 204, 235, 2),
                Color.fromARGB(255, 255, 34, 14),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

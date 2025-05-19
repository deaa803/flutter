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

  final String baseUrl =
      'http://192.168.1.7:8000/storage/'; // رابط السيرفر لتخزين الصور

  @override
  void initState() {
    super.initState();
    fetchAnimal();
  }

  Future<void> fetchAnimal() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final data = await apiService.getAnimals();
      setState(() {
        animal = data;
      });
    } catch (e) {
      print("خطأ في تحميل الحيوانات: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: fetchAnimal,
        child:
            animal.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/picture/4.json',
                        width: 250,
                        height: 250,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "لا توجد حيوانات بعد",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: animal.length,
                  itemBuilder: (context, i) {
                    final imageUrl =
                        animal[i]['image'] != null && animal[i]['image'] != ''
                            ? baseUrl + animal[i]['image']
                            : null;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    AnimalDetailsPage(animal: animal[i]),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:
                                    imageUrl != null
                                        ? Image.network(
                                          imageUrl,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              "assets/images/6.jpg",
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return SizedBox(
                                              height: 200,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value:
                                                      loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                        : Image.asset(
                                          "assets/images/6.jpg",
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "الاسم: ${animal[i]["name"]}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "العمر: ${animal[i]["age"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Cairo",
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "النوع: ${animal[i]["animal_type"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Cairo",
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "تاريخ الإضافة: ${animal[i]["date"]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Cairo",
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
              const SnackBar(
                content: Text("تمت إضافة الحيوان بنجاح!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
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

class AnimalDetailsPage extends StatefulWidget {
  final Map<String, dynamic> animal;

  const AnimalDetailsPage({super.key, required this.animal});

  @override
  State<AnimalDetailsPage> createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage> {
  late Map<String, dynamic> animal;
  DateTime? lastVisitDate;

  @override
  void initState() {
    super.initState();
    animal = widget.animal;
    if (animal['last_vet_visit'] != null) {
      lastVisitDate = DateTime.tryParse(animal['last_vet_visit']);
    }
  }

  Future<void> saveVisitDate(DateTime date) async {
    setState(() {
      lastVisitDate = date;
      animal['last_vet_visit'] = date.toIso8601String();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تحديث تاريخ آخر زيارة')));
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://192.168.1.7:8000/storage/';
    String imageUrl = baseUrl + (animal['image'] ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحيوان')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  animal['image'] != null && animal['image'] != ''
                      ? Image.network(
                        imageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 60,
                            ),
                          );
                        },
                      )
                      : Image.asset(
                        "assets/images/6.jpg",
                        height: 200,
                        fit: BoxFit.cover,
                      ),
            ),
            const SizedBox(height: 20),
            Text(
              'الاسم: ${animal['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'العمر: ${animal['age']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'نوع الحيوان: ${animal['animal_type']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'تاريخ التسجيل: ${animal['date']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (lastVisitDate != null) ...[
              Text(
                'آخر زيارة للطبيب: ${lastVisitDate!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 10),
            ],
            ElevatedButton.icon(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: lastVisitDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  locale: const Locale("ar", "SY"),
                );

                if (selectedDate != null) {
                  await saveVisitDate(selectedDate);
                }
              },
              icon: const Icon(Icons.date_range),
              label: Text(
                lastVisitDate == null
                    ? 'حدد تاريخ آخر زيارة للطبيب'
                    : 'تعديل تاريخ آخر زيارة للطبيب',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

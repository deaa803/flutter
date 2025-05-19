// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:vetlink1/serves/noti_serves.dart';

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
    final url = Uri.parse(
      'http://192.168.1.7:8000/api/animals/${animal['id']}',
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'last_vet_visit': date.toIso8601String()}),
    );

    if (response.statusCode == 200) {
      setState(() {
        lastVisitDate = date;
        animal['last_vet_visit'] = date.toIso8601String();
      });
      // جدولة الإشعار بعد أسبوعين من تاريخ الزيارة
      final notifyDate = tz.TZDateTime.from(
        date.add(const Duration(minutes: 3)),
        tz.local,
      );
      await NotificationService().scheduleNotification(
        id: animal['id'],
        title: 'موعد زيارة الطبيب',
        body: 'حان وقت أخذ ${animal['name']} إلى الطبيب البيطري.',
        scheduledDate: notifyDate,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التاريخ وجدولة التذكير بنجاح')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء حفظ التاريخ')),
      );
    }
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
              child: Image.network(
                imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 60),
                  );
                },
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
            // Center(
            //   child: Expanded(
            //     child: ElevatedButton.icon(
            //       onPressed: () async {
            //         final selectedDate = await showDatePicker(
            //           context: context,
            //           initialDate: lastVisitDate ?? DateTime.now(),
            //           firstDate: DateTime(2020),
            //           lastDate: DateTime.now(),
            //           locale: const Locale("ar", "SY"),
            //         );

            //         if (selectedDate != null) {
            //           await saveVisitDate(selectedDate);
            //         }
            //       },
            //       icon: const Icon(Icons.date_range),
            //       label: Text(
            //         lastVisitDate == null
            //             ? 'حدد تاريخ آخر زيارة للطبيب'
            //             : 'تعديل تاريخ آخر زيارة للطبيب',
            //       ),
            //       style: ElevatedButton.styleFrom(
            //         padding: const EdgeInsets.symmetric(vertical: 15),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

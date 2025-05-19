// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DoctorDetails extends StatelessWidget {
  final String name;
  final String specialty;
  final int experience;
  final String imagePath;

  const DoctorDetails({
    super.key,
    required this.name,
    required this.specialty,
    required this.experience,
    this.imagePath = 'assets/images/4.jpg',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الطبيب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 70, backgroundImage: AssetImage(imagePath)),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              specialty,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'خبرة: $experience سنوات',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // هنا ممكن تضيف منطق تواصل، مثلاً فتح شاشة دردشة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ميزة التواصل قيد التطوير')),
                );
              },
              icon: const Icon(Icons.chat),
              label: const Text('تواصل مع الطبيب'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

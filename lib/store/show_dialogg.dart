// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowDialogg extends StatefulWidget {
  const ShowDialogg({super.key});

  @override
  State<ShowDialogg> createState() => _ShowDialoggState();
}

class _ShowDialoggState extends State<ShowDialogg> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final dateController = TextEditingController();

  final List<String> animalTypes = ['Dog', 'Cat', 'Bird', 'Fish'];
  String? selectedAnimalType;

  void showWarning(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تحذير'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسنًا'),
              ),
            ],
          ),
    );
  }

  Future<void> addAnimal() async {
    // الحصول على ID المستخدم من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    final url = Uri.parse('http://192.168.43.134:8000/api/add-animals');
    var request =
        http.MultipartRequest('POST', url)
          ..fields['name'] = nameController.text
          ..fields['age'] = ageController.text
          ..fields['date'] = dateController.text
          ..fields['animal_type'] = selectedAnimalType ?? ''
          ..fields['id_user'] =
              userId
                  .toString() // إرسال ID المستخدم
          ..headers['Accept'] = 'application/json';

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print('Response: $respStr');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة الحيوان بنجاح')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في إضافة الحيوان')));
        print(response.statusCode);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('خطأ في الاتصال بالخادم')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة حيوان جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameController, 'الاسم'),
              const SizedBox(height: 12),
              _buildTextField(ageController, 'العمر', TextInputType.number),
              const SizedBox(height: 12),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: _inputDecoration('التاريخ'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    String formattedDate = DateFormat(
                      'yyyy-MM-dd',
                    ).format(pickedDate);
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedAnimalType,
                hint: const Text('اختر نوع الحيوان'),
                decoration: _inputDecoration(),
                items:
                    animalTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimalType = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: _buttonStyle(),
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          ageController.text.isEmpty ||
                          dateController.text.isEmpty ||
                          selectedAnimalType == null) {
                        showWarning('الرجاء تعبئة جميع الحقول واختيار النوع.');
                      } else {
                        addAnimal();
                      }
                    },
                    child: const Text("إضافة"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: _buttonStyle(),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("إغلاق"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType? keyboardType,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration([String? label]) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

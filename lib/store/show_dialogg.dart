// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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

  bool isLoading = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void showWarning(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تحذير', textAlign: TextAlign.right),
            content: Text(message, textAlign: TextAlign.right),
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
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    final uri = Uri.parse('http://192.168.1.7:8000/api/add-animals');
    var request = http.MultipartRequest('POST', uri);

    // حقول النص
    request.fields['name'] = nameController.text;
    request.fields['age'] = ageController.text;
    request.fields['date'] = dateController.text;
    request.fields['animal_type'] = selectedAnimalType ?? '';
    request.fields['id_user'] = userId.toString();

    // صورة إذا موجودة
    if (_imageFile != null) {
      var length = await _imageFile!.length();
      var multipartFile = http.MultipartFile(
        'image',
        _imageFile!.openRead(),
        length,
        filename: _imageFile!.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      setState(() {
        isLoading = false;
      });

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة الحيوان بنجاح')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في إضافة الحيوان')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('خطأ في الاتصال بالخادم')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة حيوان جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(nameController, 'الاسم'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        ageController,
                        'العمر',
                        TextInputType.number,
                      ),
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
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedAnimalType,
                        hint: const Text(
                          'اختر نوع الحيوان',
                          textAlign: TextAlign.right,
                        ),
                        decoration: _inputDecoration(),
                        items:
                            animalTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type, textAlign: TextAlign.right),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAnimalType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // عرض الصورة وزر اختيارها
                      Column(
                        children: [
                          _imageFile == null
                              ? const Text('لم يتم اختيار صورة')
                              : Image.file(_imageFile!, height: 150),
                          TextButton.icon(
                            onPressed: pickImage,
                            icon: const Icon(Icons.image),
                            label: const Text('اختر صورة للحيوان'),
                          ),
                        ],
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
                                showWarning(
                                  'الرجاء تعبئة جميع الحقول واختيار النوع.',
                                );
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
      textAlign: TextAlign.right,
    );
  }

  InputDecoration _inputDecoration([String? label]) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetlink1/store/main_page.dart'; // عدّل حسب مكان MainPage

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isLoading = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // رابط السيرفر - عدّل حسب IP أو اسم النطاق عندك
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/sanctum/token');

      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'device_name': 'flutter_app',
        },
      );

      if (response.statusCode == 200) {
        final token = response.body;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        await fetchUserData(token);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم تسجيل الدخول بنجاح")));

        navigateToMain();
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ?? 'خطأ في تسجيل الدخول';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/register');

      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'name': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'password_confirmation': passwordController.text.trim(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم إنشاء الحساب بنجاح، قم بتسجيل الدخول"),
          ),
        );
        setState(() {
          isLogin = true;
        });
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "خطأ في إنشاء الحساب";
        if (errorData is Map && errorData.containsKey('errors')) {
          final errors = errorData['errors'] as Map;
          errorMsg = errors.values
              .map((list) => (list as List).join(", "))
              .join("\n");
        } else if (errorData.containsKey('message')) {
          errorMsg = errorData['message'];
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserData(String token) async {
    final url = Uri.parse('$baseUrl/user');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data['name'] ?? '');
      await prefs.setString('useremail', data['email'] ?? '');
      await prefs.setInt('userId', data['id'] ?? 0);
    } else {
      print('Failed to fetch user data: ${response.body}');
    }
  }

  void navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(onToggleTheme: () {}, isDarkMode: false),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            "assets/images/cat.jpg",
                            height: 50,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!isLogin)
                          TextFormField(
                            controller: usernameController,
                            decoration: _inputDecoration(
                              "اسم المستخدم",
                              Icons.person,
                              theme,
                            ),
                            validator: (val) {
                              if (!isLogin && (val == null || val.isEmpty)) {
                                return "يرجى إدخال اسم المستخدم";
                              }
                              return null;
                            },
                          ),
                        if (!isLogin) const SizedBox(height: 15),
                        TextFormField(
                          controller: emailController,
                          decoration: _inputDecoration(
                            "البريد الإلكتروني",
                            Icons.email,
                            theme,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "يرجى إدخال البريد الإلكتروني";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                              return "يرجى إدخال بريد إلكتروني صحيح";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: _inputDecoration(
                            "كلمة المرور",
                            Icons.lock,
                            theme,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "يرجى إدخال كلمة المرور";
                            }
                            if (val.length < 6) {
                              return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                              onPressed: () {
                                if (isLogin) {
                                  login();
                                } else {
                                  signUp();
                                }
                              },
                              child: Text(
                                isLogin ? "تسجيل الدخول" : "إنشاء حساب",
                                style: GoogleFonts.tajawal(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? "أو قم بإنشاء حساب جديد"
                                : "أو سجل دخول إلى حسابك",
                            style: GoogleFonts.tajawal(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
    ThemeData theme,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.tajawal(color: Colors.grey[700]),
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
    );
  }
}

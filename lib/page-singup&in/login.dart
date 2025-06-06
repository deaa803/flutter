// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetlink1/page-singup&in/have_account.dart';
import 'package:vetlink1/page-singup&in/sing_up.dart';
import 'package:vetlink1/store/main_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;
  GlobalKey<FormState> formstate = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => MainPage(onToggleTheme: () {}, isDarkMode: false),
        ),
      );
    }
  }

  Future<void> login() async {
    if (formstate.currentState?.validate() ?? false) {
      setState(() {
        isloading = true;
      });
      var url = Uri.parse('http://192.168.43.134:8000/api/login_new');
      var response = await http.post(
        url,
        body: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );
      setState(() {
        isloading = false;
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', data['user']['name']);
        await prefs.setString('useremail', data['user']['email']);
        await prefs.setInt('userId', data['user']['id']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => MainPage(onToggleTheme: () {}, isDarkMode: false),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "مرحباً ${data['user']['name']}",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        );
      } else {
        var error = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ: $error", style: TextStyle(fontFamily: 'Cairo')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "تسجيل الدخول",
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
        body: Form(
          key: formstate,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/2.png", height: 250),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 340,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: "البريد الإلكتروني",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "يرجى إدخال البريد الإلكتروني";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    width: 340,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        hintText: "كلمة المرور",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "يرجى إدخال كلمة المرور";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 340,
                  child:
                      isloading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: login,
                            child: const Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                HaveAccount(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

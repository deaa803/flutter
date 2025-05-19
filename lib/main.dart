import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetlink1/page-singup&in/login.dart';
import 'package:vetlink1/store/main_page.dart';
import 'package:vetlink1/serves/theme.dart';
import 'package:vetlink1/serves/noti_serves.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الإشعارات مع timezone داخل NotificationService
  await NotificationService().init();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final isLoggedIn = prefs.getString('username') != null;

  runApp(MyApp(isDarkMode: isDarkMode, isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final bool isLoggedIn;

  const MyApp({super.key, required this.isDarkMode, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VetLink',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home:
          widget.isLoggedIn
              ? MainPage(onToggleTheme: toggleTheme, isDarkMode: _isDarkMode)
              : const Login(),
    );
  }
}

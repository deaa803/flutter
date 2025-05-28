import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetlink1/page-singup&in/login.dart';
import 'package:vetlink1/store/animal.dart';
import 'package:vetlink1/store/my.dart';
import 'package:vetlink1/store/store.dart';
import 'package:vetlink1/store/vet.dart';

class MainPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MainPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  String username = "";
  String useremail = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "مستخدم";
      useremail = prefs.getString('useremail') ?? "email";
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Widget _getBody() {
    switch (selectedIndex) {
      case 0:
        return Store();
      case 1:
        return Vet();
      case 2:
        return Animal();
      case 3:
        // تمرير دالة تسجيل الخروج لصفحة My
        return My(onLogout: () => _logout(context));
      default:
        return Center(child: Text("الصفحة غير موجودة"));
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/picture/user.png"),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(height: 12),
                Text(
                  username,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  useremail,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text(
              "الرئيسية",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text("حسابي", style: TextStyle(fontFamily: 'Cairo')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => My(onLogout: () => _logout(context)),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () async {
              await _logout(context);
            },
          ),
          SwitchListTile(
            secondary: Icon(
              Icons.dark_mode,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text(
              "الوضع الليلي",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            value: widget.isDarkMode,
            onChanged: (val) {
              widget.onToggleTheme();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/picture/logo vetlink crop2.png", width: 50),
            const Text(
              " vet",
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
            const Text(
              "link",
              style: TextStyle(color: Colors.yellow, fontFamily: 'Cairo'),
            ),
          ],
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        initialActiveIndex: selectedIndex,
        items: const [
          TabItem(icon: Icons.store, title: "المتجر"),
          TabItem(icon: Icons.person_search, title: "الأطباء"),
          TabItem(icon: Icons.pets, title: "الحيوانات"),
          TabItem(icon: Icons.person, title: "حسابي"),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

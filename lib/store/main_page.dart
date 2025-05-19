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
      username =
          prefs.getString('username') ??
          "مستخدم"; // جلب الاسم أو القيمة الافتراضية
      useremail =
          prefs.getString('useremail') ??
          "email"; // صححت 'useramil' إلى 'useremail'
    });
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
        return My();
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
                    fontFamily: 'Cairo', // لو ضفت الخط في المشروع
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
                MaterialPageRoute(builder: (context) => My()),
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
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

// -------------------------------------------------------------------
class Searchone extends SearchDelegate {
  final List<String> usernames = ["naser", "mhdi", "anas", "hamza", "amaar"];
  late List<String> filterlist;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    filterlist =
        usernames
            .where(
              (element) => element.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: filterlist.length,
      itemBuilder: (context, i) {
        return ListTile(title: Text(filterlist[i]));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: usernames.length,
        itemBuilder: (context, i) {
          return ListTile(title: Text(usernames[i]));
        },
      );
    } else {
      filterlist =
          usernames
              .where(
                (element) =>
                    element.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

      return ListView.builder(
        itemCount: filterlist.length,
        itemBuilder: (context, i) {
          return ListTile(title: Text(filterlist[i]));
        },
      );
    }
  }
}

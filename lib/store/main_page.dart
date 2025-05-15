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
      useremail = prefs.getString('useramil') ?? "email";
    });
  }

  int selectedIndex = 0;
  String username = "";
  String useremail = "";

  Widget _getbody() {
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
        return Center(child: Text("page not found"));
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  onBackgroundImageError: (exception, stackTrace) {
                    exception;
                  },
                  radius: 30,
                  backgroundImage: AssetImage(
                    "assest/picture/user.png",
                  ), // صورة المستخدم
                ),
                SizedBox(height: 10),
                Text(
                  username,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: 18,
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
            title: Text("الرئيسية"),
            onTap: () {
              Navigator.pop(context); // يغلق الـ Drawer
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text("حسابي"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return My();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("تسجيل الخروج"),
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
            title: Text("الوضع الليلي"),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assest/picture/logo vetlink crop2.png", width: 50),
            const Text(" vet", style: TextStyle(color: Colors.white)),
            const Text("link", style: TextStyle(color: Colors.yellow)),
          ],
        ),
      ),
      body: _getbody(),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        initialActiveIndex: selectedIndex,
        items: [
          TabItem(icon: Icons.store, title: "store"),
          TabItem(icon: Icons.person_search, title: "doctor"),
          TabItem(icon: Icons.pets, title: "animal"),
          TabItem(icon: Icons.person, title: "my"),
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
  List<String> username = ["naser", "mhdi", "anas", "hamza", "amaar"];
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
        username
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
        itemCount: username.length,
        itemBuilder: (context, i) {
          return ListTile(title: Text(username[i]));
        },
      );
    } else {
      filterlist =
          username
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

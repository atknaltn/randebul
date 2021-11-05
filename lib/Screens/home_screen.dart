import 'package:flutter/material.dart';
import 'package:randebul/Screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const appTitle = 'Randebul';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MyHomePage> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Randebul');
  final String title = 'Randebul';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: customSearchBar,
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.calendar_today_outlined)),
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.settings)),
            ]),
            actions: <Widget>[
              IconButton(
                icon: customIcon,
                padding: const EdgeInsets.only(right: 15, left: 15),
                tooltip: 'Search',
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      // Perform set of instructions.
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar = const ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'ara...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text('Randebul');
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                padding: const EdgeInsets.only(right: 15, left: 15),
                tooltip: 'My Profile',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout_outlined),
                padding: const EdgeInsets.only(right: 15, left: 15),
                tooltip: 'Logout',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.home),
              Icon(Icons.calendar_today_outlined),
              Icon(Icons.shopping_cart),
              Icon(Icons.settings),
            ],
          ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Randebul'),
                ),
                ListTile(
                  title: const Text('Sen Makinasın Makina'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Mahmut'),
                  onTap: () {
                    Navigator.pop(context);
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

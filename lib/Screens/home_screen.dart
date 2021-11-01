import 'package:flutter/material.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.calendar_today_outlined)),
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.settings)),
            ]),
            actions: <Widget>[
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
                onPressed: () {},
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

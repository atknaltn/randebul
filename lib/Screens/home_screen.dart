import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:randebul/Screens/login_screen.dart';
import 'package:randebul/Screens/my_profile.dart';
import 'package:randebul/Screens/profilepage.dart';
import 'package:randebul/Screens/sport_professionals.dart';
import 'package:randebul/model/service_model.dart';

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
  bool hide = false;
  bool leading = true;
  int index = 0, page = 0;
  final PageController controller =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: leading,
            title: customSearchBar,
            actions: <Widget>[
              IconButton(
                icon: customIcon,
                padding: const EdgeInsets.only(right: 15, left: 15),
                tooltip: 'Search',
                onPressed: () {
                  setState(() {
                    hide = !hide;
                    leading = !leading;
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
                            hintText: 'Search in Services ...',
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
              if (!hide)
                IconButton(
                  icon: const Icon(Icons.person),
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  tooltip: 'My Profile',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProfilePage()));
                  },
                ),
              if (!hide)
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (int index) {
              setState(() {
                this.index = index;
                controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue[700],
            selectedFontSize: 13,
            unselectedFontSize: 13,
            iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "Calendar",
                icon: Icon(Icons.calendar_today_outlined),
              ),
              BottomNavigationBarItem(
                label: "Cart",
                icon: Icon(Icons.shopping_cart),
              ),
              BottomNavigationBarItem(
                label: "Settings",
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          body: PageView(
            /// [PageView.scrollDirection] defaults to [Axis.horizontal].
            /// Use [Axis.vertical] to scroll vertically.
            scrollDirection: Axis.horizontal,
            controller: controller,
            onPageChanged: (page) {
              setState(
                () {
                  index = page;
                },
              );
            },
            children: <Widget>[
              ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  RichText(
                    text: const TextSpan(
                      text: ' Most Popular Services ',
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: GestureDetector(
                            child: const Service(
                              filePath: "assets/fitness1.jpg",
                              serviceName: "Fitness",
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SportProfessionals()));
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        const Service(
                          filePath: "assets/fitness2.jpg",
                          serviceName: "Fitness",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Service(
                          filePath: "assets/healty.jpg",
                          serviceName: "Nutrition",
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Service(
                          filePath: "assets/yoga.jpg",
                          serviceName: "Yoga",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Service(
                          filePath: "assets/baglama.jpg",
                          serviceName: "Baglama",
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Service(
                          filePath: "assets/gitar.jpg",
                          serviceName: "Guitar",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Center(
                child: Icon(Icons.calendar_today_outlined),
              ),
              const Center(
                child: Icon(Icons.shopping_basket),
              ),
              const Center(
                child: Icon(Icons.settings),
              ),
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
                  child: Text('Categories'),
                ),
                ListTile(
                  title: const Text('Health'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Education'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Sports'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Music'),
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

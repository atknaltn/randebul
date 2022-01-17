import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randebul/Screens/login_screen.dart';
import 'package:randebul/Screens/my_profile.dart';
import 'package:randebul/Screens/payment.dart';
import 'package:randebul/Screens/upload_service.dart';
import 'package:randebul/Screens/sport_professionals.dart';
import 'package:randebul/model/service_model.dart';
import 'package:randebul/Screens/ChatScreen.dart';

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
  final _firestore = FirebaseFirestore.instance;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Randebul');
  final String title = 'Randebul';
  bool hide = false;
  bool leading = true;
  int index = 0, page = 0;
  final PageController controller =
      PageController(initialPage: 0, keepPage: true);
  bool isProf = false;
  Future<void> _getProf() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        isProf = value.data()!['isProfessional'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getProf();
    CollectionReference professionals = _firestore.collection('Services');
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
              if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Payment()));
              }
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
                label: "Add Fund",
                icon: Icon(Icons.wallet_giftcard),
              ),
            ],
          ),
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream:
                _firestore.collection('Services').doc('Services').snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var services = output!['Service']; // <-- Your value
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: (services[index]['userImageURL'] ==
                                              null ||
                                          services[index]['userImageURL'] == '')
                                      ? Image.asset(
                                          'assets/blankprofile.png',
                                          height: 100.0,
                                          width: 100.0,
                                        )
                                      : Image.network(
                                          services[index]['userImageURL'],
                                          height: 100.0,
                                          width: 100.0,
                                        ),
                                ),
                                const SizedBox(
                                  width: 75,
                                ),
                                Image.network(
                                  services[index]['imageURL'],
                                  fit: BoxFit.cover,
                                  height: 175,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${services[index]['serviceName']}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 150,
                                ),
                                Container(
                                  child: Text(
                                    'Price: ${services[index]['servicePrice']} \$',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                )
                              ],
                            )
                          ],
                        ));
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
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
                if (isProf == true)
                  ListTile(
                    title: const Text('Create a Service'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UploadService()));
                    },
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
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SportProfessionals()));
                  },
                ),
                ListTile(
                  title: const Text('Music'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randebul/Screens/login_screen.dart';
import 'package:randebul/Screens/my_profile.dart';
import 'package:randebul/Screens/payment.dart';
import 'package:randebul/Screens/selectdate.dart';
import 'package:randebul/Screens/upload_service.dart';
import 'package:randebul/Screens/sport_professionals.dart';
import 'package:randebul/model/service_model.dart';
import 'package:randebul/Screens/ChatScreen.dart';

import 'calendar_page.dart';

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
  String _searchValue = "";
  String _categoryValue = "";
  bool _isSearching = false;
  String imageURL = "";
  final TextEditingController _controller = new TextEditingController();
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

  Future<void> _getProfessionalImage(String uid) async {
    FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        imageURL = value.data()!['userImageURL'].toString();
      });
    });
  }

  _HomeScreenState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchValue = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchValue = _controller.text;
        });
      }
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
                      customSearchBar = ListTile(
                        leading: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: TextField(
                          autofocus: true,
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Search in Services ...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
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
              if (index == 0) {
                _isSearching = false;
                _searchValue = "";
              }
              if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Payment()));
              }
              if (index == 2) {
                print('taped');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
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
              BottomNavigationBarItem(
                label: "Calendar",
                icon: Icon(Icons.calendar_today),
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
                List list = List.filled(services.length, null, growable: false);
                int i = 0;
                int j = 0;
                if (_isSearching == false) {
                  while (i < services.length) {
                    list[i] = services[i];
                    i++;
                  }
                } else {
                  while (j < services.length) {
                    if ('${services[j]['serviceName']}'
                            .contains(_searchValue) ||
                        '${services[j]['serviceName']}'
                            .toLowerCase()
                            .contains(_searchValue) ||
                        '${services[j]['serviceName']}'
                            .contains(_searchValue.toLowerCase()) ||
                        '${services[j]['profName']}'.contains(_searchValue) ||
                        '${services[j]['profName']}'
                            .toLowerCase()
                            .contains(_searchValue) ||
                        '${services[j]['profName']}'
                            .contains(_searchValue.toLowerCase()) ||
                        '${services[j]['serviceCategory']}'
                            .contains(_searchValue) ||
                        '${services[j]['serviceCategory']}'
                            .toLowerCase()
                            .contains(_searchValue) ||
                        '${services[j]['serviceCategory']}'
                            .contains(_searchValue.toLowerCase())) {
                      list[i] = services[j];
                      i++;
                    }
                    j++;
                  }
                }
                return ListView.builder(
                  itemCount: i,
                  itemBuilder: (BuildContext context, int index) {
                    //_getProfessionalImage(list[index]['professionalUid']);
                    return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        color: Colors.transparent,
                        shadowColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        child: TextButton(
                          onPressed: () async {
                            Map selectedHizmet = {
                              'serviceName': '',
                              'serviceDuration': 0,
                              'serviceContent': '',
                              'servicePrice': 0
                            };
                            DocumentReference docRef = FirebaseFirestore
                                .instance
                                .collection('professionals')
                                .doc(list[index]['professionalUid']);
                            var response = await docRef.get();
                            dynamic veri = response.data();
                            selectedHizmet = list[index];

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectDatePage(
                                          selectedHizmet: selectedHizmet,
                                          hocaRef: veri,
                                          hocaSnapshot: response,
                                          sourcePlace: 1,
                                        )));
                            print(docRef);
                            print(response);
                            print(veri);
                          },
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: (list[index]['userImageURL'] ==
                                                null ||
                                            list[index]['userImageURL'] == '')
                                        ? Image.asset(
                                            'assets/blankprofile.png',
                                            height: 100.0,
                                            width: 100.0,
                                          )
                                        : Image.network(
                                            list[index]['userImageURL'],
                                            //list[index]['userImageURL'],
                                            height: 100.0,
                                            width: 100.0,
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 75,
                                  ),
                                  Flexible(
                                      child: Image.network(
                                    list[index]['imageURL'],
                                    fit: BoxFit.fill,
                                    height: 125,
                                    width: 250,
                                  )),
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
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${list[index]['serviceName']}',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Price: ${list[index]['servicePrice']} \$',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
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
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/logo.png'),
                    ),
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
                    _categoryValue = "Health";
                    _isSearching = true;
                    _searchValue = _categoryValue;
                  },
                ),
                ListTile(
                  title: const Text('Education'),
                  onTap: () {
                    _categoryValue = "Education";
                    _isSearching = true;
                    _searchValue = _categoryValue;
                  },
                ),
                ListTile(
                  title: const Text('Sports'),
                  onTap: () async {
                    _categoryValue = "Sports";
                    _isSearching = true;
                    _searchValue = _categoryValue;
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SportProfessionals()));*/
                  },
                ),
                ListTile(
                    title: const Text('Music'),
                    onTap: () async {
                      _categoryValue = "Music";
                      _isSearching = true;
                      _searchValue = _categoryValue;
                    }),
                ListTile(
                    title: const Text('Life Style'),
                    onTap: () async {
                      _categoryValue = "Life Style";
                      _isSearching = true;
                      _searchValue = _categoryValue;
                    }),
                ListTile(
                    title: const Text('Design'),
                    onTap: () async {
                      _categoryValue = "Design";
                      _isSearching = true;
                      _searchValue = _categoryValue;
                    }),
                ListTile(
                    title: const Text('Self-Improvment'),
                    onTap: () async {
                      _categoryValue = "Self-Improvment";
                      _isSearching = true;
                      _searchValue = _categoryValue;
                    }),
                ListTile(
                    title: const Text('Software Development'),
                    onTap: () async {
                      _categoryValue = "Software Development";
                      _isSearching = true;
                      _searchValue = _categoryValue;
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

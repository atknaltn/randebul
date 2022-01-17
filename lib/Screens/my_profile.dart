import 'package:flutter/material.dart';
import 'package:randebul/Screens/editprofile.dart';
import 'package:randebul/Screens/upgrade_pro.dart';
import 'package:randebul/Screens/upload_service.dart';
import 'package:randebul/model/user.dart';
import 'package:randebul/utils/user_preferences.dart';
import 'package:randebul/widget/appbar_widget.dart';
import 'package:randebul/widget/button_widget.dart';
import 'package:randebul/widget/numbers_widget.dart';
import 'package:randebul/widget/profile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String firstname = "";
  String lastname = "";
  String mail = "";
  String phoneNumber = "";
  String address = "";
  String userName = "";
  String uid = "";
  String image = "";
  bool isProf = false;
  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        uid = value.data()!['uid'].toString();
        firstname = value.data()!['firstName'].toString();
        lastname = value.data()!['surName'].toString();
        mail = value.data()!['email'].toString();
        phoneNumber = value.data()!['phoneNumber'].toString();
        address = value.data()!['adress'].toString();
        userName = value.data()!['userName'].toString();
        isProf = value.data()!['isProfessional'];
        image = value.data()!['imageURL'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    _getUserName();
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: image,
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        EditProfile(firstname, lastname, mail, uid)),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          buildName(firstname + " " + lastname, mail),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: buildUpgradeButton(uid),
          ),
          const SizedBox(
            height: 24,
          ),
          NumbersWidget(),
          const SizedBox(
            height: 24,
          ),
          buildAbout(user),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: buildCreateAppointmentButton(),
          ),
        ],
      ),
    );
  }

  Widget buildName(String name, String mail) => Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            mail,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );
  Widget buildUpgradeButton(String uid) => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () async {
          FirebaseFirestore.instance
              .collection('users')
              .doc((FirebaseAuth.instance.currentUser)!.uid)
              .update({'isProfessional': true});
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const UpgradePro()),
          );
        },
      );

  Widget buildAbout(Userr user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.about,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      );

  Widget buildCreateAppointmentButton() => ButtonWidget(
        text: 'Create Appointment',
        onClicked: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UploadService(),
          ));
        },
      );
}

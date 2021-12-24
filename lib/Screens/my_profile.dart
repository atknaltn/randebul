import 'package:flutter/material.dart';
import 'package:randebul/Screens/editprofile.dart';
import 'package:randebul/model/user.dart';
import 'package:randebul/utils/user_preferences.dart';
import 'package:randebul/widget/appbar_widget.dart';
import 'package:randebul/widget/button_widget.dart';
import 'package:randebul/widget/numbers_widget.dart';
import 'package:randebul/widget/profile_widget.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          buildName(user),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: buildUpgradeButton(),
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

  Widget buildName(Userr user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );
  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
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
        onClicked: () {},
      );
}

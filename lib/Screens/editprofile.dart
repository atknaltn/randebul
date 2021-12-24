import 'package:flutter/material.dart';
import 'package:randebul/model/user.dart';
import 'package:randebul/utils/user_preferences.dart';
import 'package:randebul/widget/appbar_widget.dart';
import 'package:randebul/widget/profile_widget.dart';
import 'package:randebul/widget/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String firstname = "";
  String lastname = "";
  String mail = "";
  String uid = "";
  EditProfile(String firstname, String lastname, String mail, String uid,
      {Key? key})
      : super(key: key) {
    this.firstname = firstname;
    this.lastname = lastname;
    this.mail = mail;
    this.uid = uid;
  }

  @override
  _EditProfileState createState() =>
      _EditProfileState(firstname, lastname, mail);
}

class _EditProfileState extends State<EditProfile> {
  Userr user = UserPreferences.myUser;
  String firstname = "";
  String lastname = "";
  String mail = "";
  String uid = "";
  _EditProfileState(String firstname, String lastname, String mail) {
    this.firstname = firstname;
    this.lastname = lastname;
    this.mail = mail;
    this.uid = uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.all(32),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            isEdit: true,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'First Name',
            text: firstname,
            onChanged: (name) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({'firstName': name});
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Last Name',
            text: lastname,
            onChanged: (name) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({'lastName': name});
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'email',
            text: mail,
            onChanged: (email) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({'email': email});
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'About',
            text: user.about,
            maxLines: 5,
            onChanged: (about) {},
          ),
        ],
      ),
    );
  }
}

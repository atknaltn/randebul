import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      _EditProfileState(firstname, lastname, mail, uid);
}

class _EditProfileState extends State<EditProfile> {
  Userr user = UserPreferences.myUser;
  String firstname = "";
  String lastname = "";
  String mail = "";
  String uid = "";
  File? imageFile;
  var formKey = GlobalKey<FormState>();
  _EditProfileState(
      String firstname, String lastname, String mail, String uid) {
    this.firstname = firstname;
    this.lastname = lastname;
    this.mail = mail;
    this.uid = uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formKey,
      appBar: buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.all(32),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
              child: imageFile == null
                  ? TextButton(
                      onPressed: () {
                        _showDialog();
                      },
                      child: Icon(
                        Icons.add_a_photo_sharp,
                        size: 80,
                        color: Color(0xffff2fc3),
                      ))
                  : Image.file(
                      imageFile!,
                      width: 400,
                      height: 400,
                    )),
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
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              primary: const Color(0xff1b447b),
            ),
            child: Container(
              margin: const EdgeInsets.all(12),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'halter',
                  fontSize: 14,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
            onPressed: () {
              uploadImage();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
              title: Text("You want take a photo from ?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        openGallery();
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        openCamera();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> openGallery() async {
    var picture =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture!.path);
    });
  }

  Future<void> openCamera() async {
    var picture =
        await ImagePicker.platform.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture!.path);
    });
  }

  Future<void> uploadImage() async {
    String? imageURL;
    //if (formKey.currentState!.validate()) {
    Reference reference = FirebaseStorage.instance.ref().child("images").child(
        new DateTime.now().millisecondsSinceEpoch.toString() +
            "." +
            imageFile!.path);
    UploadTask uploadTask = reference.putFile(imageFile!);
    imageURL = await (await uploadTask).ref.getDownloadURL();
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("Data");
    String? uploadID = databaseReference.push().key;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'imageURL': imageURL});
    //}
  }
}

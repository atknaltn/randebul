import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randebul/model/user_model.dart';

import 'home_screen.dart';

class professionValidator {
  static String? validate(String? value) {
    RegExp regex = RegExp(r'^.{3,}$');
    if (value!.isEmpty) {
      return ("Username cannot be Empty");
    }
    if (!regex.hasMatch(value)) {
      return ("Enter Valid username(Min. 3 Character)");
    }
    return null;
  }
}

class aboutValidator {
  static String? validate(String? value) {
    if (value!.isEmpty) {
      return ("First Name cannot be Empty");
    }
    return null;
  }
}

class websiteValidator {
  static String? validate(String? value) {
    return null;
  }
}

class UpgradePro extends StatefulWidget {
  const UpgradePro({Key? key}) : super(key: key);

  @override
  _UpgaredeProState createState() => _UpgaredeProState();
}

class _UpgaredeProState extends State<UpgradePro> {
  //FORM KEY
  final _formKey = GlobalKey<FormState>();
  //Firebase connection
  final _auth = FirebaseAuth.instance;
  // string for displaying the error Message
  String? errorMessage;

  final professionController = TextEditingController();
  final aboutController = TextEditingController();
  final websiteController = TextEditingController();
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

  Future<void> updateFireBase() async {
    FirebaseFirestore.instance
        .collection('professionals')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .set({
      'uid': uid,
      'adress': address,
      'about': aboutController.text,
      'imageURL': image,
      'mail': mail,
      'name': firstname,
      'firstName': firstname,
      'lastName': lastname,
      'phonenumber': phoneNumber,
      'profession': professionController.text,
      'point': 0,
      'surname': lastname,
      'username': userName,
      'verified': true,
      'website': websiteController.text
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .update({'isProfessional': true});
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();

    final profession = TextFormField(
      autofocus: false,
      controller: professionController,
      keyboardType: TextInputType.name,
      validator: professionValidator.validate,
      onSaved: (value) {
        professionController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "What is your profession ?",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    //first name field
    final about = TextFormField(
      autofocus: false,
      controller: aboutController,
      keyboardType: TextInputType.name,
      validator: aboutValidator.validate,
      onSaved: (value) {
        aboutController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Can you talk a little bit about yourself?",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final website = TextFormField(
      autofocus: false,
      controller: websiteController,
      keyboardType: TextInputType.name,
      validator: websiteValidator.validate,
      onSaved: (value) {
        websiteController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "If yes, can you post your website?",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final signUpButton = Material(
      elevation: 5,
      color: Colors.red,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          updateFireBase();
        },
        child: const Text(
          "Upgrade Pro",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 0.0),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/logo_400.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    profession,
                    const SizedBox(
                      height: 10,
                    ),
                    about,
                    const SizedBox(
                      height: 10,
                    ),
                    website,
                    const SizedBox(
                      height: 10,
                    ),
                    signUpButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        //print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.surName = surnameController.text;
    userModel.phoneNumber = phoneNumberController.text;
    userModel.userName = userNameController.text;
    userModel.adress = adressController.text;
    userModel.isProfessional = false;
    userModel.amount = 0.0;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }*/
}

import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:randebul/Screens/home_screen.dart';
import 'package:randebul/model/service_model_last.dart';

class UploadService extends StatefulWidget {
  const UploadService({Key? key}) : super(key: key);

  @override
  _UploadServiceState createState() => _UploadServiceState();
}

class _UploadServiceState extends State<UploadService> {
  File? imageFile;
  var formKey = GlobalKey<FormState>();
  var serviceName, servicePrice, serviceDuration, serviceDefinition;
  String serviceCategory = "Sports";
  final _auth = FirebaseAuth.instance;
  String userImage = "";
  String profName = "";
  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        userImage = value.data()!['imageURL'];
        profName = value.data()!['firstname'] + " " + value.data()!['lastname'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()));
            },
          ),
          title: Text(
            "Create a Service",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                    child: imageFile == null
                        ? TextButton(
                            onPressed: () {
                              _showDialog();
                            },
                            child: Icon(
                              Icons.add_a_photo_sharp,
                              size: 80,
                              color: Colors.blue,
                            ))
                        : Image.file(
                            imageFile!,
                            width: 400,
                            height: 400,
                          )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Theme(
                          data: ThemeData(
                            hintColor: Colors.blue,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please write a service name";
                              } else {
                                serviceName = value;
                              }
                            },
                            style: TextStyle(color: Colors.blue),
                            decoration: InputDecoration(
                              labelText: "Service Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Theme(
                          data: ThemeData(
                            hintColor: Colors.blue,
                          ),
                          child: DropdownButton<String>(
                            value: serviceCategory,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.blue),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                serviceCategory = newValue!;
                              });
                            },
                            items: <String>[
                              'Health',
                              'Education',
                              'Sports',
                              'Music',
                              'Life Style',
                              'Design',
                              'Self-Improvment',
                              'Software Development'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Theme(
                          data: ThemeData(
                            hintColor: Colors.blue,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please write a service price";
                              } else {
                                servicePrice = value;
                              }
                            },
                            style: TextStyle(color: Colors.blue),
                            decoration: InputDecoration(
                              labelText: "Service Price",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Theme(
                          data: ThemeData(
                            hintColor: Colors.blue,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please write the duration of service";
                              } else {
                                serviceDuration = value;
                              }
                            },
                            style: TextStyle(color: Colors.blue),
                            decoration: InputDecoration(
                              labelText: "Service Duration",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1)),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: Theme(
                      data: ThemeData(
                        hintColor: Colors.blue,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please write the definition of service";
                          } else {
                            serviceDefinition = value;
                          }
                        },
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          labelText: "Service Definition",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)),
                        ),
                      )),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () {
                      if (imageFile == null) {
                        Fluttertoast.showToast(
                            msg: "Please select an image first",
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG);
                      } else {
                        Navigator.pop(context, 'OK');

                        uploadImage();
                        Fluttertoast.showToast(
                            msg: "The service has been created.");
                      }
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Icon(
                        Icons.upload_sharp,
                        size: 150,
                      ),
                    ))
              ],
            ),
          ),
        ));
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
    if (formKey.currentState!.validate()) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(new DateTime.now().millisecondsSinceEpoch.toString() +
              "." +
              imageFile!.path);
      UploadTask uploadTask = reference.putFile(imageFile!);
      imageURL = await (await uploadTask).ref.getDownloadURL();
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child("Data");
      String? uploadID = databaseReference.push().key;
      HashMap map = new HashMap();
      map["serviceName"] = serviceName;
      map["serviceCategory"] = serviceCategory;
      map["servicePrice"] = servicePrice;
      map["imageURL"] = imageURL;
      map["userImageURL"] = userImage;
      databaseReference.child(uploadID!).set(map);

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      ServiceModel serviceModel = ServiceModel(
          serviceName: serviceName,
          serviceCategory: serviceCategory,
          servicePrice: servicePrice,
          imageURL: imageURL,
          userImageURL: userImage);
      await firebaseFirestore.collection("Services").doc('Services').update({
        'Service': FieldValue.arrayUnion([
          {
            'imageURL': imageURL,
            'serviceCategory': serviceCategory,
            'serviceName': serviceName,
            'servicePrice': int.parse(servicePrice),
            'userImageURL': userImage,
            'professionalUid': (await FirebaseAuth.instance.currentUser)!.uid,
            'serviceDuration': int.parse(serviceDuration),
            'serviceContent': serviceDefinition,
            'profName': profName
          }
        ])
      });
      FirebaseFirestore.instance
          .collection('professionals')
          .doc((await FirebaseAuth.instance.currentUser)!.uid)
          .update({
        'Service': FieldValue.arrayUnion([
          {
            'serviceDuration': int.parse(serviceDuration),
            'servicePrice': int.parse(servicePrice),
            'serviceContent': serviceDefinition,
            'serviceName': serviceName,
          }
        ])
      });
    }
  }
}

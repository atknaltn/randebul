import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadService extends StatefulWidget {
  const UploadService({Key? key}) : super(key: key);

  @override
  _UploadServiceState createState() => _UploadServiceState();
}

class _UploadServiceState extends State<UploadService> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000725),
      appBar: AppBar(
        backgroundColor: Color(0xffff2fc3),
        title: const Text(
          "Create a Service",
          style: TextStyle(color: Color(0xffffffff)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                          color: Color(0xffff2fc3),
                        ))
                    : Image.file(
                        imageFile!,
                        width: 400,
                        height: 400,
                      )),
            ElevatedButton(
                onPressed: () {
                  if (imageFile == null) {
                    Fluttertoast.showToast(
                        msg: "Please select an image first",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_LONG);
                  } else {
                    uploadImage();
                  }
                },
                child: Icon(
                  Icons.upload_sharp,
                  size: 150,
                ))
          ],
        ),
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
    Reference reference = FirebaseStorage.instance.ref().child("images").child(
        new DateTime.now().millisecondsSinceEpoch.toString() +
            "." +
            imageFile!.path);
    UploadTask uploadTask = reference.putFile(imageFile!);
  }
}

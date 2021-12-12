// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

class Service extends StatelessWidget {
  final String filePath;

  /// Here is your constructor
  const Service({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTitle(filePath);
  }

  Widget _buildTitle(String filePath) {
    return new Align(
        child: new Container(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 120,
        width: 175,
        child: Image.asset(
          filePath,
          fit: BoxFit.fill,
        ),
      ),
    ));
  }
}

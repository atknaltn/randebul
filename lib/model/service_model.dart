// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

class Service extends StatelessWidget {
  final String filePath;
  final String serviceName;

  /// Here is your constructor
  const Service({Key? key, required this.filePath, required this.serviceName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTitle(filePath, serviceName);
  }

  Widget _buildTitle(String filePath, String serviceName) {
    return new Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 120,
            width: 175,
            child: Image.asset(
              filePath,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Text(serviceName)
      ],
    );
  }
}

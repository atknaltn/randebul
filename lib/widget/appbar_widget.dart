import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = Icons.check;

  return AppBar(
    leading: const BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon),
        color: Colors.black,
        onPressed: () {},
      )
    ],
  );
}

import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = Icons.check;

  return AppBar(
    leading: BackButton(
      color: Colors.blueGrey,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed: () {},
      )
    ],
  );
}

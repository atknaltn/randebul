import 'package:flutter/material.dart';
import 'package:randebul/Screens/my_profile.dart';
import 'body.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/testProfile.jpg'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mitat Enes Özdemir",
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  "last seen 3 minutes ago",
                  style: TextStyle(fontSize: 11),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.accessible_forward_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyProfilePage()),
              );
            },
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: Body(),
    );
  }
}

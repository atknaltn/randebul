import 'package:flutter/material.dart';
import 'package:randebul/Screens/my_profile.dart';
import 'body.dart';

class ChatScreen extends StatelessWidget {
  final dynamic messageRef;
  final String id;
  const ChatScreen({Key? key, required this.messageRef, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: (messageRef['imageURL'] != '' &&
                      messageRef['imageURL'] != 'null')
                  ? Image.network(
                      messageRef['imageURL'],
                      height: 40,
                      width: 40,
                    )
                  : Image.asset(
                      'assets/blankprofile.png',
                      height: 40,
                      width: 40,
                    ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageRef['firstName'] + ' ' + messageRef['lastName'],
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  "last seen 5 minutes ago",
                  style: TextStyle(fontSize: 11),
                )
              ],
            )
          ],
        ),
      ),
      body: Body(ref: messageRef, id: id),
    );
  }
}

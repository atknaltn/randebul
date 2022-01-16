import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randebul/Screens/chat_input_field.dart';
import 'package:randebul/model/ChatMessage.dart';
import 'package:randebul/Screens/message.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1000.0);

  @override
  Widget build(BuildContext context) {
    CollectionReference mesajlarRef = _firestore.collection('mesajlar');

    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return StreamBuilder<QuerySnapshot>(
        stream: mesajlarRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.data == null)
            return const CircularProgressIndicator();
          dynamic mesajList = asyncSnapshot.data.docs;

          dynamic mesajArr = <Map>[];
          mesajArr = mesajList[0].data()['mesajlar'];
          mesajlarRef.doc('mesaj1').collection('mesajlar');
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: mesajList[0].data()['mesajlar'].length,
                    itemBuilder: (context, index) => Message(
                      message: ChatMessage(
                        messageStatus: MessageStatus.viewed,
                        messageType: ChatMessageType.text,
                        isSender: mesajArr[index]['issender'],
                        text: mesajArr[index]['mesajmetni'],
                      ),
                    ),
                  ),
                ),
              ),
              ChatInputField(
                  messagesRef: mesajlarRef, asyncSnapshot: asyncSnapshot),
            ],
          );
        });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }
}

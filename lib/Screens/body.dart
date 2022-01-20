import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randebul/Screens/chat_input_field.dart';
import 'package:randebul/model/ChatMessage.dart';
import 'package:randebul/Screens/message.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatefulWidget {
  final String id;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Body({Key? key, required this.id}) : super(key: key);

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
    CollectionReference ref = _firestore.collection('professionals');
    final User? user = widget.auth.currentUser;
    final String uid = user!.uid;

    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

    return StreamBuilder<QuerySnapshot>(
        stream: mesajlarRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.data == null)
            return const CircularProgressIndicator();
          dynamic mesajList = asyncSnapshot.data.docs;

          dynamic mesajArr = <Map>[];
          mesajArr = mesajList[1].data()['mesajlar'];
          //mesajlarRef.doc('mesaj1').collection('mesajlar');
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: mesajList[1].data()['mesajlar'].length,
                    itemBuilder: (context, index) => (mesajArr[index]['idTo'] ==
                                widget.id &&
                            mesajArr[index]['idFrom'] == uid)
                        ? Message(
                            message: ChatMessage(
                              messageStatus: MessageStatus.viewed,
                              messageType: ChatMessageType.text,
                              isSender: true,
                              text: mesajArr[index]['mesajmetni'],
                              date:
                                  DateFormat('dd.MM.y').format(DateTime.now()),
                            ),
                          )
                        : (mesajArr[index]['idFrom'] == widget.id &&
                                mesajArr[index]['idTo'] == uid)
                            ? Message(
                                message: ChatMessage(
                                  messageStatus: MessageStatus.viewed,
                                  messageType: ChatMessageType.text,
                                  isSender: false,
                                  text: mesajArr[index]['mesajmetni'],
                                  date: DateFormat('dd.MM.y')
                                      .format(DateTime.now()),
                                ),
                              )
                            : SizedBox(width: 0, height: 0),
                  ),
                ),
              ),
              ChatInputField(
                messagesRef: mesajlarRef,
                profRef: ref,
                asyncSnapshot: asyncSnapshot,
                id: widget.id,
              )
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

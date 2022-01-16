import 'package:flutter/material.dart';
import 'package:randebul/model/ChatMessage.dart';
import 'package:randebul/model/message_dao.dart';
//import 'package:randebul/model/message_widget.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInputField extends StatelessWidget {
  final CollectionReference messagesRef;
  final AsyncSnapshot asyncSnapshot;
  const ChatInputField({
    required this.messagesRef,
    required this.asyncSnapshot,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _messageController = TextEditingController();
    ScrollController _scrollController = ScrollController();
    void _scrollToBottom() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color(0xFF087949).withOpacity(0.08)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0 * 0.75, vertical: 10.0),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sentiment_satisfied_alt_outlined,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.6),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                      //  onChanged: (text) => setState(() {}),
                      onSubmitted: (input) {
                        messagesRef.doc('mesaj1').update({
                          'mesajlar': FieldValue.arrayUnion([
                            {
                              'mesajmetni': input,
                              'issender': true,
                            }
                          ])
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.6),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.6),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

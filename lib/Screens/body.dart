import 'package:flutter/material.dart';
import 'package:randebul/Screens/chat_input_field.dart';
import 'package:randebul/model/ChatMessage.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              itemCount: demeChatMessages.length,
              itemBuilder: (context, index) => Message(
                message: demeChatMessages[index],
              ),
            ),
          ),
        ),
        const ChatInputField(),
      ],
    );
  }
}

class Message extends StatelessWidget {
  const Message({
    Key? key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment:
            message!.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message!.isSender) ...[
            const CircleAvatar(
              radius: 11,
              backgroundImage: AssetImage("assets/TestProfile.jpg"),
            ),
            const SizedBox(
              width: 10.0,
            )
          ],
          TextMessage(message: message),
        ],
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);
  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20.0 * 0.75, vertical: 10.0),
        decoration: BoxDecoration(
          color:
              const Color(0xFF00BF6D).withOpacity(message!.isSender ? 1 : 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          message!.text,
          style: TextStyle(
              color: message!.isSender
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1?.color),
        ));
  }
}

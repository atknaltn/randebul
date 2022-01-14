import 'package:flutter/material.dart';
import 'package:randebul/model/ChatMessage.dart';
import 'package:randebul/Screens/text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage? message;
  @override
  Widget build(BuildContext context) {
    Widget chat(ChatMessage? message) {
      switch (message?.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);

        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment:
            message!.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message!.isSender) ...[
            const CircleAvatar(
              radius: 11,
              backgroundImage: AssetImage("assets/testProfile.jpg"),
            ),
            const SizedBox(
              width: 10.0,
            )
          ],
          chat(message),
          if (message!.isSender)
            MessageStatusDot(status: message?.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;
  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color? dotColor(MessageStatus? status) {
      switch (status) {
        case MessageStatus.not_sent:
          return Colors.red;
        case MessageStatus.not_viewed:
          return Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.1);
        case MessageStatus.viewed:
          return Color(0xFF00BF6D);
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 20.0 / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 7,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

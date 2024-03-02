import 'package:watheq/Interviews/model/message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;
    final backgroundColor = isMe
        ? Theme.of(context).colorScheme.primary
        : Colors
            .white; //Blue background if sent by user, white if sent by Chat-GPT
    final color = isMe
        ? Colors.white
        : Theme.of(context)
            .colorScheme
            .primary; //white text if sent by user, blue if sent by Chat-GPT

    return Container(
      margin: const EdgeInsets.all(10),
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft, //Alignment of the message
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.75, //Width of the message
        ),
        child: Material(
          borderRadius: BorderRadius.circular(50).copyWith(
            topLeft: !isMe ? const Radius.circular(0) : null,
            topRight: isMe ? const Radius.circular(0) : null,
          ),
          color: backgroundColor,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message.text,
              style: TextStyle(color: color, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

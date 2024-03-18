import 'package:watheq/Interviews/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Container(
      margin: const EdgeInsets.all(10),
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft, //Alignment of the message
      child: Container(
        constraints: message.isTyping
            ? const BoxConstraints(
                minWidth: 60,
                maxWidth:
                    100) // Adjust the width constraints for the typing indicator
            : BoxConstraints(maxWidth: maxWidth),
        child: Material(
          borderRadius: BorderRadius.circular(45).copyWith(
            topLeft: !isMe ? const Radius.circular(0) : null,
            topRight: isMe ? const Radius.circular(0) : null,
          ),
          color: backgroundColor,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: message.isTyping
                ? Row(
                    mainAxisSize:
                        MainAxisSize.min, // Use minimum space for the row
                    children: [
                      SpinKitThreeBounce(
                        color: Color(0xFF024A8D),
                        size: 20.0,
                      ),
                    ],
                  )
                : Text(
                    message.text,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                    ),
                    //  textAlign: TextAlign.justify,
                  ),
          ),
        ),
      ),
    );
  }
}

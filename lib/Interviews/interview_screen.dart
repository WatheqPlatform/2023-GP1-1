import 'package:watheq/Interviews/model/message.dart';
import 'package:watheq/interviews/widget/message_bubble_widget.dart';
import 'package:watheq/interviews/widget/new_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class Interviews extends StatefulWidget {
  const Interviews({super.key});

  @override
  _Interviews createState() => _Interviews();
}

class _Interviews extends State<Interviews> {
  //List of Messages
  List<Message> messages = [
    Message(
      text: 'Yes sure!',
      date: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      text: 'Do you have time tomorrow?',
      date: DateTime.now().subtract(const Duration(minutes: 2)),
      isSentByMe: true,
    ),
  ].reversed.toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 42,
                        color: Color(0xFF024A8D),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "Mock Interview",
                            style: TextStyle(
                              color: Color(0xFF024A8D),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.060,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GroupedListView<Message, DateTime>(
                padding: const EdgeInsets.all(4),
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: messages,
                groupBy: (message) => DateTime(
                  message.date.year,
                  message.date.month,
                  message.date.day,
                ),
                groupHeaderBuilder: (Message message) =>
                    SizedBox(), //Header is always needed
                //Message Content
                itemBuilder: (context, Message message) =>
                    MessageBubble(message: message),
              ),
            ),

            // The text field for adding new message by user
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  left: 7,
                ),
                child: NewMessageWidget(
                  //Event listner
                  onSubmitted: (text) {
                    final message = Message(
                      text: text,
                      date: DateTime.now(),
                      isSentByMe: true,
                    );

                    // Adding the message to the list
                    setState(() => messages.add(message));
                  },
                ),
              ),
            )
          ],
        ),
      );
}

import 'package:watheq/Interviews/model/message.dart';
import 'package:watheq/interviews/widget/message_bubble_widget.dart';
import 'package:watheq/interviews/widget/new_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/database_connection/connection.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Interviews extends StatefulWidget {
  final String offerID;
  final String email;

  // Constructor
  const Interviews({required this.offerID, required this.email});

  @override
  _Interviews createState() => _Interviews();
}

class _Interviews extends State<Interviews> {
  List<String> questions = [];
  List<String> answers = [];

  int questionIndex = 0;
  var thread_id;

  //List of Messages
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInstructionsDialog();
    });
  }

  void showInstructionsDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Interview Instructions',
      desc:
          'Please read the following instructions carefully to ensure a successful interview simulation.',
      btnOkColor: Color(0xFF024A8D),
      btnOkOnPress: () {
        startInterview(
            null); // Start the interview after the user closes the dialog
      },
    )..show();
  }

  Future<void> startInterview(String? text) async {
    final typingMessage = Message(
      text: '', // No text needed for typing indicator
      date: DateTime.now(),
      isSentByMe: false,
      isTyping: true,
    );
    setState(() {
      messages.add(typingMessage);
    });

    var url = Uri.parse(Connection.Interview);
    var response;
    var status = 'start';

    if (questionIndex == 0) {
      status = "start";
    } else if (questionIndex == 10) {
      status = "last";
    } else {
      status = "next";
    }
    if (questionIndex == 0) {
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'status': status,
          'offerId': widget.offerID,
          'email': widget.email
        }),
      );
    } else {
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "status": status,
          "answer": text,
          "thread_id": thread_id, // Send the user's answer
        }),
      );
    }

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);

      var python = data["result"];

      print(python);

      int questionIndexx = python.indexOf('"question"');

      int firstQIndex =
          python.indexOf('"', questionIndexx + '"question"'.length);
      int nextQIndex = python.indexOf('"', firstQIndex + 1);

      String question = python.substring(firstQIndex + 1, nextQIndex);
      question = question.replaceAll('\n ', '');

      setState(() {
        messages.removeWhere((msg) => msg.isTyping);
        messages.add(
          Message(
            text: question,
            date: DateTime.now().subtract(const Duration(minutes: 1)),
            isSentByMe: false,
          ),
        );
      });

      int threadIdIndex = python.indexOf('"thread_id"');

      int firstQuotationIndex =
          python.indexOf('"', threadIdIndex + '"thread_id"'.length);

      int nextQuotationIndex = python.indexOf('"', firstQuotationIndex + 1);

      String threadId =
          python.substring(firstQuotationIndex + 1, nextQuotationIndex);
      print(threadId);

      print(question);
      if (question.isNotEmpty) {
        setState(() {
          print(questionIndex);
          questions.add(question);
          thread_id = threadId;
        });
      }
    } else {
      setState(() {
        questions.add("Error: Status code ${response.statusCode}");
      });
    }
  }

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
                    setState(() {
                      messages.add(message);
                      if (questionIndex != 10) {
                        questionIndex++;
                      }
                    });
                    startInterview(text);
                  },
                  isEnabled: questionIndex < 10,
                ),
              ),
            )
          ],
        ),
      );
}

import 'package:flutter/material.dart';

class RequiredFieldLabel extends StatefulWidget {
  final String labelText;
  bool hideStar;
  Color starColor ;
  RequiredFieldLabel({required this.labelText, this.hideStar = false, this.starColor = Colors.red});

  @override
  _RequiredFieldLabelState createState() => _RequiredFieldLabelState();
}

class _RequiredFieldLabelState extends State<RequiredFieldLabel> {
  bool showMessage = false;
  final message = "this field is Required";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showMessage = !showMessage;
            });
          },
          child: Row(
            children: [
              Text(
                widget.labelText,
                style: const TextStyle(color: Color(0xFF085399)), // Label color
              ),
              if (!widget.hideStar)Text(
                ' *' + (showMessage ? message : ''),
                style: TextStyle(color: widget.starColor),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
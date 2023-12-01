// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';

class RequiredFieldLabel extends StatefulWidget {
  final String labelText;
  bool hideStar;
  Color starColor ;
  RequiredFieldLabel({super.key, required this.labelText, this.hideStar = false, this.starColor = Colors.red});

  @override
  _RequiredFieldLabelState createState() => _RequiredFieldLabelState();
}

class _RequiredFieldLabelState extends State<RequiredFieldLabel> {
  bool showMessage = false;
  String message = "Required field";

  @override
  Widget build(BuildContext context) {
    if (widget.starColor == Colors.green) {
      message = 'This field is required for this addition';
    }
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
                ' *${showMessage ? message : ''}',
                style: TextStyle(color: widget.starColor),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
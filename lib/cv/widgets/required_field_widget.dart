// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:watheq/cv/widgets/required_label.dart';

class RequiredFieldWidget extends StatelessWidget {
  final String label;
  final String? keyName;
  int maxLines;
  TextInputType keyboardType;
  bool hideStar;
  Color starColor;
  final TextEditingController controller;
  final int maxLength;
  bool removeGutter = false;

  RequiredFieldWidget(
      {super.key,
      required this.label,
      this.keyName,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.hideStar = false,
      this.starColor = Colors.red,
      this.removeGutter = false,
      this.maxLength = 50});
  String? validatePhone(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    RegExp pattern = RegExp(r'^05\d{8}$');
    if (value.length != 10 || !value.startsWith(pattern)) {
      return 'Please enter a valid saudi number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validateShortText(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > maxLength) {
      return 'Maximum text size is ${maxLength} for this field';
    }
    return null;
  }

  String? validateLongText(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > 500) {
      return 'Maximum text length is 500 for this field';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: removeGutter ? 0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequiredFieldLabel(
            labelText: label,
            starColor: starColor,
            hideStar: hideStar,
          ),
          TextFormField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            validator: (String? val) {
              if (keyName == 'phoneNumber') return validatePhone(val);
              if (keyName == 'contactEmail') return validateEmail(val);
              if (maxLines == 1) {
                return validateShortText(val);
              }
              if (maxLines == 5) {
                return validateShortText(val);
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            key: keyName != null ? Key(keyName!) : null,
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF14386E),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF14386E),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 0.012,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

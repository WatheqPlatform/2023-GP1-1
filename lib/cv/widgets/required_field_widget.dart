// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:watheq/cv/widgets/required_label.dart';

class RequiredFieldWidget extends StatelessWidget {
  final String label;
  final String? keyName;
  int maxLines ;
  TextInputType keyboardType;
  bool hideStar;
  Color starColor ;
  final TextEditingController controller;
  RequiredFieldWidget({super.key, required this.label, this.keyName, required this.controller, this.keyboardType =  TextInputType.text, this.maxLines = 1, this.hideStar = false, this.starColor = Colors.red});
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    RegExp pattern = RegExp(r'^05\d{8}$');
    if (value.length != 10 || !value.startsWith(pattern)) {
      return 'Please enter a valid Saudi Number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  String ? validateShortText(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > 50) {
      return 'Maximum Text size is 50 for this field';
    }
    return null;
  }
  String ? validateLongText(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > 500) {
      return 'Maximum Text size is 500 for this field';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequiredFieldLabel(labelText: label, starColor: starColor,hideStar: hideStar,),
            TextFormField(
              keyboardType: keyboardType,
            maxLines: maxLines,
            validator: (String? val) {
                if (keyName == 'phoneNumber') return validatePhone(val);
                if (keyName == 'contactEmail') return validateEmail(val);
                if (maxLines == 1) {
                  return validateShortText(val);
                }
                if (maxLines == 5) {
                  return validateLongText(val);
                }
                return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,


            controller: controller,
            key: keyName != null ? Key(keyName!) : null,
            decoration: InputDecoration(
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
                horizontal:  8.0,
                vertical:  0.012,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

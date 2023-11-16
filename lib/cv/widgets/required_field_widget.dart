import 'package:flutter/material.dart';
import 'package:watheq/cv/widgets/required_label.dart';

class RequiredFieldWidget extends StatelessWidget {
  final String label;
  final String keyName;
  final TextEditingController controller;
  RequiredFieldWidget({required this.label, required this.keyName, required this.controller});
  String? validatePhone(String? value) {
    if (value is Null || value.isEmpty) {
      return null;
    }
    if (value.length != 10 || !value.startsWith(RegExp(r'[0-9]'))) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value is Null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequiredFieldLabel(labelText: label,),
            TextFormField(
              keyboardType: keyName == 'phoneNumber' ? TextInputType.phone : keyName == 'contactEmail' ? TextInputType.emailAddress : TextInputType.text,
            validator: (String? val) {
              print(val);
                if (keyName == 'phoneNumber') return validatePhone(val);
                if (keyName == 'contactEmail') return validateEmail(val);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,


            controller: controller,
            key: Key(keyName),
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
              contentPadding: EdgeInsets.symmetric(
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

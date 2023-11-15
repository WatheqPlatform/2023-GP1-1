import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_picker_dialog.dart';

class DateButton extends StatefulWidget {
  final String label;
  final TextEditingController dateController;

   DateButton({Key? key, required this.label, required this.dateController}) : super(key: key);

  @override
  State<DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  DateTime? date ;
  @override
  Widget build(BuildContext context) {
    final f =  DateFormat('yyyy/MM/dd');
    return Container(
        margin: EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.label,
                  style:
                      const TextStyle(color: Color(0xFF085399)), // Label color
                ),
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                date = await showBookPublishDatePicker();
                if (kDebugMode) {
                  print(date.toString());
                }
                setState(() {
                  widget.dateController.text = f.format(date ?? DateTime.now());

                });
              },
              child: Container(
                height: 50,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFF14386E),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:  8.0,
                    vertical:  0.012,
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(widget.dateController.text),
                      ],
                    ),
                  ),
                ),),
            ),
          ],
        ));
  }
}

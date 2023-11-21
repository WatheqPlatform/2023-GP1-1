// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:watheq/cv/widgets/required_label.dart';

import 'date_picker_dialog.dart';


enum DatePickerButtonMode {
  month,
  year,
  day,
}

class DateButton extends StatefulWidget {
  final String label;
  final TextEditingController dateController;
  bool hideStar;
  Color starColor ;
  DatePickerButtonMode mode ;
  DateTime? lastDate ;
   DateButton({Key? key, required this.label, required this.dateController,this.hideStar = false, this.starColor = Colors.red, this.mode = DatePickerButtonMode.day, this.lastDate}) : super(key: key);

  @override
  State<DateButton> createState() => _DateButtonState();
}


class _DateButtonState extends State<DateButton> {
  DateTime? date ;

  @override
  Widget build(BuildContext context) {
    final f =  DateFormat('yyyy/MM/dd');
    return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            RequiredFieldLabel(labelText: widget.label,hideStar: widget.hideStar, starColor: widget.starColor,),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                if (widget.mode == DatePickerButtonMode.day) {
                  date = await showBookPublishDatePicker(widget.lastDate);
                }
                else if (widget.mode == DatePickerButtonMode.year){
                  date = await showMonthlyYearlyPicker(widget.lastDate, MonthYearPickerMode.year);
                }
                else if (widget.mode == DatePickerButtonMode.month){
                  date = await showMonthlyYearlyPicker(widget.lastDate, MonthYearPickerMode.month);
                }
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
                    color: const Color(0xFF14386E),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal:  8.0,
                    vertical:  0.012,
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        if (widget.mode == DatePickerButtonMode.year && widget.dateController.text.isNotEmpty) Text(widget.dateController.text.substring(0,4))
                        else if (widget.mode == DatePickerButtonMode.month&& widget.dateController.text.isNotEmpty) Text(widget.dateController.text.substring(0,7))
                        else if (widget.mode == DatePickerButtonMode.day&& widget.dateController.text.isNotEmpty) Text(widget.dateController.text)
                      ],
                    ),
                  ),
                ),),
            ),
          ],
        ));
  }
}

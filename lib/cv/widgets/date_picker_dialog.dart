import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';

Future<DateTime?> showBookPublishDatePicker(DateTime? lastDate) async {
  DateTime? selectedDate = await showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(1980,1,1),
    lastDate: lastDate ?? DateTime(2030, 1, 1),
  );

  return selectedDate;
}


Future<DateTime?> showMonthlyYearlyPicker(DateTime? lastDate, MonthYearPickerMode mode) async {

  DateTime? selectedDate = await showMonthYearPicker(
    context: Get.context!,
    initialDate: DateTime(DateTime.now().year),
    firstDate: DateTime(1980),
    lastDate: lastDate ?? DateTime(2030),
    initialMonthYearPickerMode: mode
  );

  return selectedDate;
}

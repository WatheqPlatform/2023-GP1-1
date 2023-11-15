import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<DateTime?> showBookPublishDatePicker() async {
  DateTime? selectedDate = await showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900,1,1),
    lastDate: DateTime.now(),
  );

  return selectedDate;
}

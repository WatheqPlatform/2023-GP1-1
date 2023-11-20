import 'package:month_year_picker/month_year_picker.dart';
import 'package:watheq/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Watheq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 11, 15, 121),
          primary: const Color(0xFF085399),
        ),
        fontFamily: 'Poppins',
      ),
      localizationsDelegates: [
        MonthYearPickerLocalizations.delegate,
      ],
      home: const StartScreen(),
    );
  }
}

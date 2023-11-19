import 'package:watheq/offers_screen.dart';
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
      home: const OffersScreen(email: "sarona1017@gmail.com"),
    );
  }
}

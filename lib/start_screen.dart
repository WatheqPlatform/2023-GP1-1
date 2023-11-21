// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:watheq/Authentication/signup_screen.dart';
import 'package:watheq/Authentication/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LaunchColor.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              "assets/images/WatheqLogo.png",
              width: screenWidth * 0.65,
            ),
            const SizedBox(height: 80),
            Container(
              width: double.infinity,
              height: screenHeight * 0.41,
              padding: EdgeInsets.all(screenWidth * 0.1),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3B000000),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    "Improve Your Career",
                    style: TextStyle(
                      color: Color(0xFF14386E),
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Discover endless career possibilities. Your journey begins here!",
                    style: TextStyle(
                      color: Color(0xffd714386e),
                      fontSize: 17.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF024A8D),
                      fixedSize: Size(screenWidth * 0.8, screenHeight * 0.056),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 1.5,
                        color: Color(0xFF024A8D),
                      ),
                      fixedSize: Size(screenWidth * 0.8, screenHeight * 0.052),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF024A8D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

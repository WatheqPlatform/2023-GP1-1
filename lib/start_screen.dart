import 'package:flutter/material.dart';
import 'package:watheq/Authentication/signup_screen.dart';
import 'package:watheq/Authentication/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LaunchColor.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          //color: const Color.fromARGB(163, 2, 74, 141),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/WatheqLogo.png",
                width: 280,
              ),
              //Padding between element
              const SizedBox(
                height: 80,
              ),
              Container(
                width: double.infinity,
                height: screenHeight * 0.40,
                padding: const EdgeInsets.only(
                  top: 60.0,
                  right: 40.0,
                  bottom: 20.0,
                  left: 40.0,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90.0),
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
                    const Text(
                      "Improve Your Career",
                      style: TextStyle(
                        color: Color(0xFF14386E),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //Padding between element
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      "Discover endless career possibilities Your journey begins here!",
                      style: TextStyle(
                        color: Color(0xffd714386e),
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    //Padding between element
                    const SizedBox(
                      height: 30,
                    ),
                    //Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF024A8D),
                        fixedSize: const Size(325, 50),
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
                    //Padding between element
                    const SizedBox(
                      height: 17,
                    ),
                    //Sign In Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 1.5,
                          color: Color(0xFF024A8D),
                        ),
                        fixedSize: const Size(325, 47),
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
      ),
    );
  }
}

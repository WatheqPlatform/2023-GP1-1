import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/Authentication/new_password_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:watheq/error_messages.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.email});
  final String email;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var formKey = GlobalKey<FormState>();
  var codeController = TextEditingController(); // users inputs
  var isObsecure = true.obs;

  bool codefilled = false;

  @override
  void initState() {
    codefilled = false;
    super.initState();
  }

  //Verify code function
  verify() async {
    try {
      var response = await http.post(Uri.parse(Connection.verifyToken),
          body: json.encode(
              {"email": widget.email, "code": codeController.text.trim()}),
          headers: {"Content-type": "application/json"});

      if (response.statusCode == 200) {
        // communication is succefull
        var res = jsonDecode(response.body.trim());

        if (res.containsKey('message')) {
          Get.to(() => NewPasswordScreen(email: widget.email));
        } else {
          if (context.mounted) {
            ErrorMessage.show(context, "Error", res["error"],
                ContentType.failure, Color.fromARGB(255, 209, 24, 24));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMessage.show(context, "Error", "Please check your connection.",
            ContentType.failure, Color.fromARGB(255, 209, 24, 24));
      }
    }
  }

  forgetPassword() async {
    try {
      var response = await http.post(
        Uri.parse(Connection.forgetPassword),
        body: json.encode({
          "email": widget.email,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // communication is succefull
        var res = jsonDecode(response.body.trim());

        if (res.containsKey('message')) {
          if (context.mounted) {
            ErrorMessage.show(
              context,
              "Success",
              "The email has been sent successfully.",
              ContentType.success,
              Color.fromARGB(255, 15, 152, 20),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMessage.show(
            context,
            "Error",
            "The email is incorrect, please try again.",
            ContentType.failure,
            Color.fromARGB(255, 209, 24, 24));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/PagesBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: 2),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 1),
                  child: Text(
                    "Verify Code",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 27.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 220),
            Container(
              width: double.infinity,
              height: screenHeight * 0.63,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.03,
                horizontal: screenWidth * 0.1,
              ),
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
                  const SizedBox(height: 45),
                  const Text(
                    "You're Almost There! ",
                    style: TextStyle(
                      color: Color(0xFF14386E),
                      fontSize: 29.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "Enter the verification code sent to your email",
                    style: TextStyle(
                      color: Color(0xffd714386e),
                      fontSize: 17.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 160, bottom: 3),
                          child: Text(
                            "Verification Code",
                            style: TextStyle(
                              color: Color(0xFF14386E),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: TextFormField(
                            controller: codeController,
                            validator: (value) {
                              if (value == "") {
                                codefilled = false;
                              } else if (value != "") {
                                codefilled = true;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_person,
                                color: Color.fromARGB(102, 20, 56, 110),
                              ),
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
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.012,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (codefilled) {
                                verify();
                                codeController.clear();
                              } else {
                                return ErrorMessage.show(
                                    context,
                                    "Error",
                                    "Please enter the verification code.",
                                    ContentType.failure,
                                    Color.fromARGB(255, 209, 24, 24));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF024A8D),
                            fixedSize:
                                Size(screenWidth * 0.8, screenHeight * 0.056),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Verify",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 17),
                        OutlinedButton(
                          onPressed: () {
                            forgetPassword();
                            codeController.clear();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1.5,
                              color: Color(0xFF024A8D),
                            ),
                            fixedSize:
                                Size(screenWidth * 0.8, screenHeight * 0.052),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Re-Send",
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
          ],
        ),
      ),
    );
  }
}

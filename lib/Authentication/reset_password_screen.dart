// ignore_for_file: void_checks

import 'dart:async';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/Authentication/verification_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:watheq/error_messages.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(); // users inputs
  var isObsecure = true.obs;

  bool emailfilled = false;
  bool validemail = false;

  @override
  void initState() {
    emailfilled = false;
    validemail = false;
    super.initState();
  }

//sending code
  forgetPassword() async {
    try {
      var response = await http.post(
        Uri.parse(Connection.forgetPassword),
        body: json.encode({
          "email": emailController.text.trim(),
        }),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body.trim());

        if (res.containsKey('message')) {
          if (context.mounted) {
            ErrorMessage.show(
              context,
              "Success",
              18,
              "The email has been sent successfully.",
              ContentType.success,
              const Color.fromARGB(255, 15, 152, 20),
            );
            Timer(const Duration(seconds: 2), () {
              Get.to(VerificationScreen(email: emailController.text.trim()));
            });
          }
        } else {
          if (context.mounted) {
            ErrorMessage.show(
                context,
                "Error",
                18,
                "The email is incorrect, please try again.",
                ContentType.failure,
                const Color.fromARGB(255, 209, 24, 24));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMessage.show(context, "Error", 18, "Please check your connection.",
            ContentType.failure, const Color.fromARGB(255, 209, 24, 24));
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
                    "Forget Password",
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
                    "Account Recovery",
                    style: TextStyle(
                      color: Color(0xFF14386E),
                      fontSize: 29.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "Enter the email address associated with your account to send you the reset code",
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
                          padding: EdgeInsets.only(right: 265, bottom: 3),
                          child: Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xFF14386E),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == "") {
                                emailfilled = false;
                              } else if (value != "") {
                                emailfilled = true;
                              }
                              if (!EmailValidator.validate(value.toString())) {
                                validemail = false;
                              } else {
                                validemail = true;
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
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
                              if (emailfilled) {
                                if (validemail) {
                                  forgetPassword();
                                } else {
                                  return ErrorMessage.show(
                                      context,
                                      "Error",
                                      18,
                                      "Please enter a valid email.",
                                      ContentType.failure,
                                      const Color.fromARGB(255, 209, 24, 24));
                                }
                              } else {
                                return ErrorMessage.show(
                                    context,
                                    "Error",
                                    18,
                                    "Please enter the email.",
                                    ContentType.failure,
                                    const Color.fromARGB(255, 209, 24, 24));
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
                            "Send Email",
                            style: TextStyle(
                              fontSize: 18,
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

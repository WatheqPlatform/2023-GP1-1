// ignore_for_file: void_checks, use_full_hex_values_for_flutter_colors

import 'dart:async';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/database_connection/connection.dart';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:watheq/error_messages.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String? sessionID;

  const NewPasswordScreen({Key? key, required this.email, this.sessionID})
      : super(key: key); // Modify this line
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();

  var isObsecure = true.obs;

  bool passfilled = false;
  bool validpass = false;

  bool pass2filled = false;
  bool validpass2 = false;

  @override
  void initState() {
    passfilled = false;
    validpass = false;
    pass2filled = false;
    validpass2 = false;
    super.initState();
  }

  //validate password
  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  //reset function
  resetPassword() async {
    try {
      var response = await http.put(
        Uri.parse(Connection.resetPassword),
        body: json.encode({
          "email": widget.email,
          "password": passwordController.text.trim(),
          "session_id": widget.sessionID
        }),
      );

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body.trim());

        print(resBody);

        if (resBody.containsKey('message')) {
          if (context.mounted) {
            ErrorMessage.show(
              context,
              "Success",
              18,
              "The password has been resetted successfully.",
              ContentType.success,
              const Color.fromARGB(255, 15, 152, 20),
            );

            Timer(const Duration(seconds: 2), () {
              Get.to(const LoginScreen());
            });
          }
        } else {
          if (context.mounted) {
            ErrorMessage.show(
                context,
                "Error",
                18,
                "The reset code has expired, please request a new one",
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
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                      Get.to(LoginScreen());
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, left: 1),
                    child: Text(
                      "Reset Password",
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomInsets),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 45),
                        const Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Color(0xFF14386E),
                            fontSize: 29.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          "Enter your new password",
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
                                padding: EdgeInsets.only(right: 210, bottom: 3),
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                    color: Color(0xFF14386E),
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.8,
                                child: Column(
                                  children: [
                                    Obx(
                                      () => TextFormField(
                                        controller: passwordController,
                                        obscureText: isObsecure.value,
                                        validator: (value) {
                                          if (value == "") {
                                            passfilled = false;
                                          } else if (value != "") {
                                            passfilled = true;
                                          }
                                          if (!validateStructure(
                                              value.toString())) {
                                            validpass = false;
                                          } else {
                                            setState(() {
                                              validpass = true;
                                            });
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key,
                                            color: Color.fromARGB(
                                                102, 20, 56, 110),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                                  !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: const Color(0xFF14386E),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF14386E),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                    const SizedBox(height: 20),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 80, bottom: 3),
                                      child: Text(
                                        "Password Confirmation",
                                        style: TextStyle(
                                          color: Color(0xFF14386E),
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => TextFormField(
                                        controller: password2Controller,
                                        obscureText: isObsecure.value,
                                        validator: (value) {
                                          if (value == "") {
                                            pass2filled = false;
                                          } else if (value != "") {
                                            pass2filled = true;
                                          }
                                          if (passwordController.text
                                                  .toString()
                                                  .toLowerCase() !=
                                              password2Controller.text
                                                  .toString()
                                                  .toLowerCase()) {
                                            validpass2 = false;
                                          } else {
                                            setState(() {
                                              validpass2 = true;
                                            });
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key,
                                            color: Color.fromARGB(
                                                102, 20, 56, 110),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                                  !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: const Color(0xFF14386E),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF14386E),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                          if (passfilled && pass2filled) {
                                            if (validpass) {
                                              if (validpass2) {
                                                resetPassword();
                                              } else {
                                                return ErrorMessage.show(
                                                    context,
                                                    "Error",
                                                    14,
                                                    "The confirmation password does not match the new password",
                                                    ContentType.failure,
                                                    const Color.fromARGB(
                                                        255, 209, 24, 24));
                                              }
                                            } else {
                                              return ErrorMessage.show(
                                                  context,
                                                  "Error",
                                                  18,
                                                  "Please enter valid Password: 8 characters, one uppercase letter, one lowercase letter, one digit and one special character",
                                                  ContentType.failure,
                                                  const Color.fromARGB(
                                                      255, 209, 24, 24));
                                            }
                                          } else {
                                            return ErrorMessage.show(
                                                context,
                                                "Error",
                                                18,
                                                "Please enter the password",
                                                ContentType.failure,
                                                const Color.fromARGB(
                                                    255, 209, 24, 24));
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF024A8D),
                                        fixedSize: Size(screenWidth * 0.8,
                                            screenHeight * 0.056),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: const Text(
                                        "Reset Password",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

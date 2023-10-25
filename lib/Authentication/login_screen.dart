// ignore_for_file: use_build_context_synchronously, void_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Authentication/reset_password_screen.dart';
import 'package:watheq/Authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/database_connection/connection.dart';
import 'dart:convert';
import 'package:watheq/offers_screen.dart';
import 'package:watheq/start_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:watheq/error_messages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObscure = true.obs;

  bool emailfilled = false;
  bool passfilled = false;

  @override
  void initState() {
    emailfilled = false;
    passfilled = false;
    super.initState();
  }

  logInUser() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF024A8D),
            ),
          );
        },
      );
      var response = await http.post(
        Uri.parse(Connection.logIn),
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(response.body.trim());

        if (resBodyOfLogin == 1) {
          Get.offAll(OffersScreen(
            email: emailController.text,
          ));
        } else {
          ErrorMessage.show(
              context,
              "Error",
              18,
              "The email or password is incorrect, please try again",
              ContentType.failure,
              const Color.fromARGB(255, 209, 24, 24));
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartScreen()),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 1),
                  child: Text(
                    "Sign In",
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
                    "Welcome Back!",
                    style: TextStyle(
                      color: Color(0xFF14386E),
                      fontSize: 29.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "We are happy to see you again",
                    style: TextStyle(
                      color: Color(0xffd714386e),
                      fontSize: 17.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 262, bottom: 3),
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
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(right: 224, bottom: 3),
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
                                  obscureText: isObscure.value,
                                  validator: (value) {
                                    if (value == "") {
                                      passfilled = false;
                                    } else if (value != "") {
                                      passfilled = true;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.key,
                                      color: Color.fromARGB(102, 20, 56, 110),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        isObscure.value = !isObscure.value;
                                      },
                                      child: Icon(
                                        isObscure.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF14386E),
                                      ),
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
                              GestureDetector(
                                onTap: () {
                                  Get.to(const ForgetPasswordScreen());
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 3, right: 150),
                                  child: Text(
                                    "Forgot Your Password?",
                                    style: TextStyle(
                                      color: Color(0xFF14386E),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (emailfilled && passfilled) {
                                logInUser();
                              } else {
                                return ErrorMessage.show(
                                    context,
                                    "Error",
                                    18,
                                    "Please fill all the information.",
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
                            "Sign In",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color(0xFF14386E),
                          fontSize: 15.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(const SignUpScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 67, left: 5),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color(0xFF14386E),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
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

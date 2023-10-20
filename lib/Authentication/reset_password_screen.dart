import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:watheq_app/Authentication/verification_screen.dart';
import 'package:watheq_app/database_connection/connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(); // users inputs
  var isObsecure = true.obs;

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
        // communication is succefull
        var res = jsonDecode(response.body.trim());

        if (res.containsKey('message')) {
          //true
          Fluttertoast.showToast(msg: "Email sent successfully");
          Get.to(VerificationScreen(email: emailController.text.trim()));
        } else {
          Fluttertoast.showToast(
              msg: "The email is incorrect, please try again");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            // to adjust the screen and have the style
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              // if the screen is small
              child: Column(
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      //container of the form
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(241, 246, 245, 245),
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),

                      //reset password form
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8.0),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  //email field
                                  TextFormField(
                                    controller: emailController,
                                    validator: (value) =>
                                        value == "" ? "Enter your Email" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  //Verfication button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(
                                          255, 11, 15, 121),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 40),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        forgetPassword();
                                      }
                                    },
                                    child: const Text(
                                      "verify",
                                      style: TextStyle(
                                        fontSize: 17,
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Watheq/Authentication/new_password_screen.dart';
import 'package:Watheq/Authentication/reset_password_screen.dart';
import 'package:Watheq/database_connection/connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

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

  //Verify token function
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

          Fluttertoast.showToast(
              msg: "Code Is Correct Please add your new password");
        } else {
          Fluttertoast.showToast(msg: res['error']);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
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
          Fluttertoast.showToast(msg: "Email sent successfully");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    int endTime =
        DateTime.now().millisecondsSinceEpoch + 5 * 60 * 1000; // 5 minutes

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

                      //verify code  form
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8.0),
                        child: Column(
                          children: [
                            CountdownTimer(
                              endTime: endTime,
                              textStyle: const TextStyle(
                                  fontSize: 30, color: Colors.black),
                              onEnd: () {
                                Get.to(const ForgetPasswordScreen());
                              },
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  //email field
                                  TextFormField(
                                    controller: codeController,
                                    validator: (value) => value == ""
                                        ? "Enter the verification code"
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "Verification Code",
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

                                  //Verify button
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromARGB(
                                              255, 11, 15, 121),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 30),
                                        ),
                                        onPressed: () {
                                          verify();
                                        },
                                        child: const Text(
                                          "verify",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),

                                      //Resending button

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromARGB(
                                              255, 11, 15, 121),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 30),
                                        ),
                                        onPressed: () {
                                          forgetPassword();
                                        },
                                        child: const Text(
                                          "Re-Send code",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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

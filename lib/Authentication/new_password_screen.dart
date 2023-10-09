import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:watheq_app/Authentication/login_screen.dart';
import 'package:watheq_app/Authentication/reset_password_screen.dart';
import 'package:watheq_app/Authentication/signup-screen.dart';
import 'package:watheq_app/Authentication/resetpassword_screen.dart';
import 'package:http/http.dart' as http;
import 'package:watheq_app/Authentication/verification_Screen.dart';
import 'package:watheq_app/database_connection/connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:watheq_app/Authentication/user.dart';

class NewPasswordScreen extends StatefulWidget {
  NewPasswordScreen({super.key, required this.email});
  final String email;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  //log in function
  logInUser() async {
    try {
      var response = await http.put(
        Uri.parse(Connection.resetPassword),
        body: json.encode({
          "email": widget.email,
          "password": passwordController.text.trim(),
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // communication is succefull
        var resBodyOfLogin = jsonDecode(response.body.trim());

        if (resBodyOfLogin.containsKey('message')) {
          //true
          Fluttertoast.showToast(msg: "Retested successfully");
          Get.to(() => LoginScreen());
        } else {
          Fluttertoast.showToast(
              msg: "The email or password is incorrect, please try again");
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

                      //log in form
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8.0),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  //password field
                                  Obx(
                                        () => TextFormField(
                                      controller: passwordController,
                                      obscureText: isObsecure.value,
                                      validator: (value) => value == ""
                                          ? "Enter the password"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.key,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(
                                              () => GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                              !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
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
                                  ),

                                  const SizedBox(
                                    height: 22,
                                  ),

                                  //log in button
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
                                        logInUser();
                                      }
                                    },
                                    child: const Text(
                                      "Reset Password",
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // sign up button

                            // forget pass button
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

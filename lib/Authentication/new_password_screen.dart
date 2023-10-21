import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:Watheq/Authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:Watheq/database_connection/connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.email});
  final String email;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

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
        }),
      );

      if (response.statusCode == 200) {
        // communication is succefull
        var resBody = jsonDecode(response.body.trim());

        if (resBody.containsKey('message')) {
          //true
          Fluttertoast.showToast(msg: "Retested successfully");
          Get.to(() => const LoginScreen());
        } else {
          Fluttertoast.showToast(msg: resBody['error']);
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
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: passwordController,
                                      obscureText: isObsecure.value,
                                      validator: (value) {
                                        if (value == "") {
                                          return "Enter the password";
                                        }
                                        if (!validateStructure(
                                            value.toString())) {
                                          return "Enter valid Password  \n 8 characters \n one uppercase letter \n one lowercase letter \n one digit \n one special character";
                                        }
                                        return null;
                                      },
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

                                  //Reset button
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
                                        resetPassword();
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Authentication/reset_password_screen.dart';
import 'package:watheq/Authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/database_connection/connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:watheq/offers_screen.dart';

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

  logInUser() async {
    try {
      var response = await http.post(
        Uri.parse(Connection.logIn),
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(response.body.trim());

        if (resBodyOfLogin == 1) {
          Fluttertoast.showToast(msg: "Logged in successfully");
          Get.to(OffersScreen(
            email: emailController.text,
          ));
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
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
            //Header
            Row(
              children: [
                // Padding between elements
                const SizedBox(
                  width: 2,
                ),
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
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 1,
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 29.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            // Padding between elements
            const SizedBox(
              height: 180,
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.68,
              padding: const EdgeInsets.only(
                top: 65.0,
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
                  //Padding between element
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Color(0xFF14386E),
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
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
                  //Padding between element
                  const SizedBox(
                    height: 55,
                  ),
                  // Sign In Form
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            right: 270,
                            bottom: 3,
                          ),
                          child: Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xFF14386E),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        // Email
                        SizedBox(
                          width: 325,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) =>
                                value == "" ? "Enter the email" : null,
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                        // Padding between elements
                        const SizedBox(
                          height: 20,
                        ),

                        const Padding(
                          padding: EdgeInsets.only(
                            right: 230,
                            bottom: 3,
                          ),
                          child: Text(
                            "Password",
                            style: TextStyle(
                              color: Color(0xFF14386E),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        //
                        // Password
                        SizedBox(
                          width: 325,
                          child: Column(
                            children: [
                              Obx(
                                () => TextFormField(
                                  controller: passwordController,
                                  obscureText: isObscure.value,
                                  validator: (value) =>
                                      value == "" ? "Enter the password" : null,
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
                                        color: Color(0xFF14386E),
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                  ),
                                ),
                              ),
                              //clackable text
                              GestureDetector(
                                onTap: () {
                                  // Handle click action
                                  Get.to(const ForgetPasswordScreen());
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    top: 3,
                                    right: 150,
                                  ),
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
                        const SizedBox(
                          height: 20,
                        ),

                        // Submit Button
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              logInUser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF024A8D),
                            fixedSize: const Size(325, 50),
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
                  const SizedBox(
                    height: 6,
                  ),
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
                      //clackable text
                      GestureDetector(
                        onTap: () {
                          // Handle click action
                          Get.to(const SignUpScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(
                            right: 60,
                            left: 5,
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFF14386E),
                              fontSize: 15,
                            ),
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

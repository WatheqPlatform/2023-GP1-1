// ignore_for_file: void_checks, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/database_connection/connection.dart';
import 'package:watheq/Authentication/user.dart';
import 'package:watheq/start_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:watheq/error_messages.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var NameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  bool isChecked = false;

  bool namefilled = false;
  bool emailfilled = false;
  bool passfilled = false;
  bool validpass = false;
  bool validemail = false;

  @override
  void initState() {
    namefilled = false;
    emailfilled = false;
    passfilled = false;
    validemail = false;
    validpass = false;

    super.initState();
  }

//validate password
  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*_\-/?~,`]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

// validate email
  validateEmail() async {
    try {
      var response = await http.post(
        Uri.parse(Connection.validateEmail),
        body: {
          "email": emailController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        // communication is succefull
        var resBodyOfEmail = jsonDecode(response.body.trim());

        if (resBodyOfEmail == 1) {
          if (context.mounted) {
            ErrorMessage.show(
                context,
                "Error",
                18,
                "This email is already exist, please sign in.",
                ContentType.failure,
                const Color.fromARGB(255, 209, 24, 24));
          }
        } else {
          registerUser();
        }
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        ErrorMessage.show(context, "Error", 18, "Please check your connection.",
            ContentType.failure, const Color.fromARGB(255, 209, 24, 24));
      }
    }
  }

//sign up function
  registerUser() async {
    User userModel = User(
      emailController.text.trim(),
      NameController.text.trim(),
      passwordController.text.trim(),
    );

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
        Uri.parse(Connection.signUp),
        body: userModel.toJson(),
      );

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(response.body.trim());

        if (resBodyOfSignUp == 1) {
          if (context.mounted) {
            ErrorMessage.show(
              context,
              "Success",
              18,
              "You have registered successfully.",
              ContentType.success,
              const Color.fromARGB(255, 15, 152, 20),
            );

            Timer(const Duration(seconds: 2), () {
              setState(() {
                emailController.clear();
                passwordController.clear();
                NameController.clear();
              });

              Get.to(const LoginScreen());
            });
          }
        } else {
          if (context.mounted) {
            ErrorMessage.show(
                context,
                "Error",
                18,
                "Please check your connection.",
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
                    "Sign Up",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 27.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 93),
            Container(
              width: double.infinity,
              height: screenHeight * 0.77,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.03,
                horizontal: screenWidth * 0.08,
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
                    "Join Watheq Family!",
                    style: TextStyle(
                      color: Color(0xFF14386E),
                      fontSize: 29.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "We are happy to have you between us",
                    style: TextStyle(
                      color: Color(0xffd714386e),
                      fontSize: 17.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 45),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 224, bottom: 3),
                          child: Text(
                            "Full Name",
                            style: TextStyle(
                              color: Color(0xFF14386E),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: TextFormField(
                            controller: NameController,
                            validator: (value) {
                              if (value == "") {
                                namefilled = false;
                              } else {
                                namefilled = true;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
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
                          padding: EdgeInsets.only(right: 264, bottom: 3),
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
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(right: 226, bottom: 3),
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
                                    if (!validateStructure(value.toString())) {
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
                                      color: Color.fromARGB(102, 20, 56, 110),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        isObsecure.value = !isObsecure.value;
                                      },
                                      child: Icon(
                                        isObsecure.value
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
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      activeColor: const Color(0xFF14386E),
                                      checkColor: Colors.white,
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                            width: 2.0,
                                            color: Color(0xFF14386E)),
                                      ),
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = !isChecked;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "I accept the ",
                                    style: TextStyle(
                                      color: Color(0xFF14386E),
                                      fontSize: 15,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Conditions And Terms",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF14386E),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            content: const Text(
                                              "To ensure a comprehensive and realistic interview simulation experience, Watheq collaborates with a trusted third-party company. By accepting these conditions, you acknowledge and agree to the following condition regarding the sharing of your information with a third-party company: \n \na. Your information, including your responses and CV, will be shared with a third-party company for the sole purpose of completing the interview simulation and providing enhanced simulation services.\n \nb. The shared information will be limited to what is necessary to facilitate the simulation process and will not include any personal identifiers such as your activity in the app or contact details.\n \nc. The third-party company may use the shared information for learning purposes or to enhance their services.\n \nd.The third-party company will not use the shared information for any other purposes, including marketing or advertising, without your explicit consent.",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xFF14386E),
                                                  letterSpacing: 1.15),
                                            ),
                                            scrollable: true,
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFF14386E),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "conditions and terms",
                                      style: TextStyle(
                                          color: Color(0xFF14386E),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (namefilled && passfilled && emailfilled) {
                                if (validemail) {
                                  if (validpass) {
                                    if (isChecked) {
                                      validateEmail();
                                    } else {
                                      return ErrorMessage.show(
                                          context,
                                          "Error",
                                          18,
                                          "Please accept the conditions and terms to continue.",
                                          ContentType.failure,
                                          const Color.fromARGB(
                                              255, 209, 24, 24));
                                    }
                                  } else {
                                    return ErrorMessage.show(
                                        context,
                                        "Error",
                                        14,
                                        "Please enter valid Password: 8 characters, one uppercase letter, one lowercase letter, one digit and one special character",
                                        ContentType.failure,
                                        const Color.fromARGB(255, 209, 24, 24));
                                  }
                                } else {
                                  return ErrorMessage.show(
                                      context,
                                      "Error",
                                      18,
                                      "Plese enter a valid email",
                                      ContentType.failure,
                                      const Color.fromARGB(255, 209, 24, 24));
                                }
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
                            "Sign Up",
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
                        "Already have an account?",
                        style: TextStyle(
                          color: Color(0xFF14386E),
                          fontSize: 15.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(const LoginScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 52, left: 5),
                          child: Text(
                            "Sign In",
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

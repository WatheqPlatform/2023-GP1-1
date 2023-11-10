// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/offers_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/Applications_Screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String Name = '';
  String letters = "";

  String email = '';

  Future<void> fetchUserData() async {
    try {
      var response = await http
          .get(Uri.parse('${Connection.jobSeekerData}?email=${widget.email}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            Name = data[0]['Name'];
            email = data[0]['JobSeekerEmail'];

            int space = Name.indexOf(" ");
            letters += Name.substring(0, 1);
            if (space != -1) {
              letters += Name.substring(space + 1, space + 2);
              letters = letters.toUpperCase();
            }
          });
        }
      } else {
        // Handle error response
      }
    } catch (e) {
      // Handle network or API errors
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int selectedIndex = 0;
    return Scaffold(
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
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(width: 55),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 1),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                height: screenHeight * 0.86,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 40,
                                    bottom: 30,
                                    left: screenWidth * 0.05),
                                width: screenWidth * 0.5,
                                height: screenWidth * 0.5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF14386E).withOpacity(
                                    0.1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    letters,
                                    style: const TextStyle(
                                      fontSize: 90,
                                      color: Color(0xFF14386E),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Color(0xFF14386E),
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      width: screenWidth * 0.79,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFF14386E),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xFF14386E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      Name.capitalizeEach(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 37, 42, 74),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xFF14386E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 37, 42, 74),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 1.5,
                                          color: Color(0xFF024A8D),
                                        ),
                                        fixedSize: Size(screenWidth * 0.8,
                                            screenHeight * 0.052),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        "Create CV",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF024A8D),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Get.offAll(const LoginScreen());
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 1.5,
                                          color: Color.fromARGB(255, 141, 2, 2),
                                        ),
                                        fixedSize: Size(screenWidth * 0.8,
                                            screenHeight * 0.052),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        "Log Out",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 141, 2, 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      width: 370,
                      margin: EdgeInsets.only(
                        top: screenHeight * 0.76,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(29, 0, 0, 0),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      //Bottom Menu
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: GNav(
                          backgroundColor: const Color.fromARGB(
                              0, 255, 255, 255), //Navigation Background
                          color: const Color.fromARGB(
                              255, 66, 66, 66), //Unslected page icon color
                          activeColor: const Color(
                              0xFF14386E), //Selected page icon color
                          tabBackgroundColor: const Color(0xFF14386E)
                              .withOpacity(
                                  0.1), //Selected page icon background color
                          gap: 8,
                          iconSize: 24, // tab button icon size
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ), // navigation bar padding
                          tabs: const [
                            GButton(
                              icon: LineIcons.home,
                              text: 'Home',
                            ),
                            GButton(
                              icon: LineIcons.list,
                              text: 'Applications',
                            ),
                            GButton(
                              icon: LineIcons.user,
                              text: 'Profile',
                            )
                          ],
                          selectedIndex: 2,
                          onTabChange: (index) {
                            setState(
                              () {
                                selectedIndex =
                                    index; // Update the selected index
                              },
                            );
                            if (index == 0) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OffersScreen(email: widget.email),
                                ),
                              );
                            } else if (index == 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ApplicationsScreen(email: widget.email),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

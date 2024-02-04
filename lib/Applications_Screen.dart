// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/offers_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/profile_screen.dart';
import 'package:watheq/offer_details_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  final String email;

  const ApplicationsScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreen();
}

class _ApplicationsScreen extends State<ApplicationsScreen> {
  List list = [];

  Future ReadData() async {
    var res = await http.post(
      Uri.parse(Connection.jobSeekerApplication),
      body: {"email": widget.email},
    );

    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);

      setState(() {
        list = red.reversed.toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ReadData();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return const Color.fromARGB(255, 15, 152, 20);
      case 'Rejected':
        return const Color.fromARGB(255, 209, 24, 24);

      case 'Cancelled':
        return const Color.fromARGB(255, 209, 24, 24);

      default:
        return const Color.fromARGB(255, 155, 155, 155);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int selectedIndex = 1;
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
            const SizedBox(
              height: 42,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 55,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 1,
                  ),
                  child: Text(
                    "Job Applications",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 27,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.95,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
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
                child: Stack(
                  children: [
                    list.isEmpty
                        ? const Center(
                            child: Text('No Applications found.'),
                          )
                        : Expanded(
                            child: SizedBox(
                              height: screenHeight * 0.80,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(80.0),
                                ),
                                child: ListView.builder(
                                  itemCount: list.length,
                                  padding: const EdgeInsets.only(top: 35),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2,
                                        left: 15,
                                        right: 15,
                                        bottom: 5,
                                      ),
                                      child: Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          border: index == list.length - 1
                                              ? Border.all(
                                                  color: Colors.transparent)
                                              : Border(
                                                  bottom: BorderSide(
                                                    color: Color.fromARGB(
                                                        169, 158, 158, 158),
                                                    width: 0.5,
                                                  ),
                                                ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.7,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${list[index]["JobTitle"]}"
                                                          .capitalizeEach(),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF14386E),
                                                        fontSize: 21.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${list[index]["CompanyName"]} \n${list[index]["Category"]}"
                                                          .capitalizeEach(),
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 155, 155, 155),
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        children: <TextSpan>[
                                                          const TextSpan(
                                                            text: "Status: ",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      155,
                                                                      155,
                                                                      155),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "${list[index]["ApplicationStatus"]}",
                                                            style: TextStyle(
                                                              color: getStatusColor(
                                                                  "${list[index]["ApplicationStatus"]}"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 9,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 0,
                                                  right: 5,
                                                ),
                                                width: screenWidth * 0.09,
                                                height: screenHeight * 0.058,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFF024A8D),
                                                    width: 1.8,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_forward),
                                                  iconSize: 20,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              (JobOfferDetailScreen(
                                                                offerID:
                                                                    "${list[index]["OfferID"]}",
                                                                email: widget
                                                                    .email,
                                                              ))),
                                                    ).then((value) {
                                                      // This block will be executed when returning back to this screen
                                                      setState(() {
                                                        list.clear();
                                                        ReadData();
                                                      });
                                                    });
                                                  },
                                                  color:
                                                      const Color(0xFF024A8D),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      width: 350,
                      margin: EdgeInsets.only(
                        left: screenWidth * 0.072,
                        top: screenHeight * 0.8055,
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
                          selectedIndex: 1,
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
                            } else if (index == 2) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProfileScreen(email: widget.email),
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

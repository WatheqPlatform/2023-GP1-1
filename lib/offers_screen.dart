// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/profile_screen.dart';
import 'offer_details_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';

class OffersScreen extends StatefulWidget {
  final String email;

  const OffersScreen({super.key, required this.email});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String Name = "";
  List allOffers = [];
  List foundOffers = [];

  Future<void> getdata() async {
    var res = await http.get(Uri.parse(Connection.jobOffersData));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      // Update the allOffers
      setState(() {
        allOffers.addAll(red);
        foundOffers.addAll(red);
      });
    }
  }

  Future getName() async {
    var response = await http.post(
      Uri.parse(Connection.jobSeekerName),
      body: {
        "email": widget.email,
      },
    );

    if (response.statusCode == 200) {
      var nameRespose = json.decode(response.body);
      String fullName = nameRespose[0]["Name"];
      int space = fullName.indexOf(" ");
      setState(() {
        Name = fullName.substring(0, space);
        Name = Name.capitalizeEach();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    getName();
  }

  void searchOffer(String searchedWord) {
    List results = [];
    if (searchedWord.isEmpty) {
      results = allOffers;
    } else {
      results = allOffers
          .where((element) =>
              (element["JobTitle"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())) ||
              (element["CompanyName"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())) ||
              (element["CategoryName"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())))
          .toList();
    }

    setState(() {
      foundOffers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int selectedIndex = 0;
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
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          "Hello " + Name + "!",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: screenWidth * 0.809,
                        height: screenHeight * 0.045,
                        child: TextField(
                          onChanged: (value) => searchOffer(value),
                          decoration: InputDecoration(
                            hintText: "Search by job title, field, or company",
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFFD3D3D3),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: const TextStyle(
                              color: Color(0xFFD3D3D3),
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                              top: screenHeight * 0.01,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.80,
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
                  foundOffers.isEmpty
                      ? const Center(
                          // Display a message when their is no offers
                          child: Text('No job offers found.'),
                        )
                      : Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.71,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                              ),
                              child: ListView.builder(
                                itemCount: foundOffers.length,
                                padding: const EdgeInsets.only(
                                  top: 35,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2,
                                      left: 5,
                                      right: 5,
                                      bottom: 5,
                                    ),
                                    child: Container(
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        border: Border(
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
                                          left: 20,
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
                                                    "${foundOffers[index]["JobTitle"]}"
                                                        .capitalizeEach(),
                                                    style: const TextStyle(
                                                      color: Color(0xFF14386E),
                                                      fontSize: 21.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${foundOffers[index]["CompanyName"]} \n${foundOffers[index]["CategoryName"]}"
                                                        .capitalizeEach(),
                                                    //"
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
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: Text(
                                                      "Posted on ${foundOffers[index]["Date"]}"
                                                          .capitalizeEach(),
                                                      //"
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 155, 155, 155),
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
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
                                                  Get.to(
                                                    () => JobOfferDetailScreen(
                                                      offerID:
                                                          foundOffers[index]
                                                              ["OfferID"],
                                                    ),
                                                  );
                                                },
                                                color: const Color(0xFF024A8D),
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
                      left: screenWidth * 0.07,
                      top: screenHeight * 0.725,
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
                        activeColor:
                            const Color(0xFF14386E), //Selected page icon color
                        tabBackgroundColor: const Color(0xFF14386E).withOpacity(
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
                        selectedIndex: 0,
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
          ],
        ),
      ),
    );
  }
}

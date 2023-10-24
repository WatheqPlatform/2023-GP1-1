// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobOfferDetailScreen extends StatefulWidget {
  var offerID;

  JobOfferDetailScreen({
    super.key,
    required this.offerID,
  });

  @override
  State<JobOfferDetailScreen> createState() => _StateJobOfferDetailScreen();
}

class _StateJobOfferDetailScreen extends State<JobOfferDetailScreen> {
  List offerDetails = [];

  bool empty = true;

  Future<void> getdata() async {
    var res = await http.post(
      Uri.parse(Connection.jobDetailData),
      body: {"ID": widget.offerID},
    );

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      setState(() {
        offerDetails.addAll(red);
        empty = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  //checking optional fields value

  Widget startingDateCheck() {
    if (offerDetails[0]["StartingDate"] != null &&
        offerDetails[0]["StartingDate"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Starting Date'),
            subtitle: Text("${offerDetails[0]["StartingDate"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget workingDaysCheck() {
    if (offerDetails[0]["WorkingDays"] != null &&
        offerDetails[0]["WorkingDays"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Working Days'),
            subtitle: Text("${offerDetails[0]["WorkingDays"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget workingHoursCheck() {
    if (offerDetails[0]["WorkingHours"] != null &&
        offerDetails[0]["WorkingHours"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Working Hours'),
            subtitle: Text("${offerDetails[0]["WorkingHours"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget notesCheck() {
    if (offerDetails[0]["AdditionalNotes"] != null &&
        offerDetails[0]["AdditionalNotes"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Additional Notes'),
            subtitle: Text("${offerDetails[0]["AdditionalNotes"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: empty
          ? null
          : Container(
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
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 1),
                        child: Text(
                          "${offerDetails[0]["JobTitle"]}",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.70,
                            child: ListView(
                              padding: const EdgeInsets.all(5),
                              children: [
                                Text(
                                  "${offerDetails[0]["JobDescription"]}",
                                  style: const TextStyle(fontSize: 17),
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                  "By ${offerDetails[0]["CompanyName"]}",
                                  style: const TextStyle(fontSize: 17),
                                  textAlign: TextAlign.justify,
                                ),
                                Text("${offerDetails[0]["CategoryName"]}"),
                                Text("${offerDetails[0]["EmploymentType"]}"),
                                Text("${offerDetails[0]["JobAddress"]}"
                                    "${offerDetails[0]["CityName"]}"),
                                Text(
                                    "${offerDetails[0]["MinSalary"]} - ${offerDetails[0]["MaxSalary"]}"),
                                Text("${offerDetails[0]["Date"]}"),
                                startingDateCheck(),
                                workingDaysCheck(),
                                workingHoursCheck(),
                                notesCheck(),
                              ],
                            ),
                          ),
                        ),
                        //Buttons
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
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
                            "Apply",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1.5,
                              color: Color(0xFF024A8D),
                            ),
                            fixedSize:
                                Size(screenWidth * 0.8, screenHeight * 0.052),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Mock Interview ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF024A8D),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
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

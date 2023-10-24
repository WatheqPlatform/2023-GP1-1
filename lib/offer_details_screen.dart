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
      red[0]['experiences'] = json.decode(red[0]['experiences']);
      red[0]['qualifications'] = json.decode(red[0]['qualifications']);
      red[0]['skills'] = json.decode(red[0]['skills']);
      
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 2),
            child: Text(
              "PStarting Day",
              style: const TextStyle(
                  fontSize: 20.0,
                  color: const Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          ListTile(
            subtitle: Text(
              "${offerDetails[0]["StartingDate"]}",
              style: const TextStyle(
                  fontSize: 18.0,
                  color: const Color(0xFF024A8D),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 2),
            child: Text(
              "Working Days",
              style: const TextStyle(
                  fontSize: 20.0,
                  color: const Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          ListTile(
            subtitle: Text(
              "${offerDetails[0]["WorkingDays"]}",
              style: const TextStyle(
                  fontSize: 18.0,
                  color: const Color(0xFF024A8D),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
  Widget renderQualifications() {
    if (offerDetails[0]['qualifications'].length > 0) {
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qualifications",
            style: const TextStyle(
                fontSize: 20.0,
                color: const Color(0xFF024A8D),
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.justify,
          ),
         SizedBox(height: 200, child:  ListView.builder(
  itemCount: offerDetails[0]['qualifications'].length,
  itemBuilder: (context, index) {
    final qualification = offerDetails[0]['qualifications'][index];

    return ListTile(
      title: Text('Degree Level: ${qualification["DegreeLevel"]}',style: const TextStyle(
          fontSize: 18.0,
          color: const Color(0xFF024A8D),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,),
      subtitle: Text(
        "Field: ${qualification['Field']}",
        style: const TextStyle(
          fontSize: 18.0,
          color: const Color(0xFF024A8D),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ),
    );
  },
)
         )
         
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

    Widget renderExpriences() {
    if (offerDetails[0]['experiences'].length > 0) {
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Experiences",
            style: const TextStyle(
                fontSize: 20.0,
                color: const Color(0xFF024A8D),
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.justify,
          ),
         SizedBox(height: 200, child:  ListView.builder(
  itemCount: offerDetails[0]['experiences'].length,
  itemBuilder: (context, index) {
    final experience = offerDetails[0]['experiences'][index];

    return ListTile(
      title: Text('Years Of Experience: ${experience["YearsOfExperience"]}',style: const TextStyle(
          fontSize: 18.0,
          color: const Color(0xFF024A8D),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,),
      subtitle: Text(
        "Field: ${experience['ExperienceField']}",
        style: const TextStyle(
          fontSize: 18.0,
          color: const Color(0xFF024A8D),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ),
    );
  },
)
         )
         
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
    Widget renderSkills() {
    if (offerDetails[0]['skills'].length > 0) {
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Skills",
            style: const TextStyle(
                fontSize: 20.0,
                color: const Color(0xFF024A8D),
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.justify,
          ),
         SizedBox(height: 200, child:  ListView.builder(
  itemCount: offerDetails[0]['skills'].length,
  itemBuilder: (context, index) {
    final skill = offerDetails[0]['skills'][index];

    return ListTile(

      subtitle: Text(
        "${skill}",
        style: const TextStyle(
          fontSize: 18.0,
          color: const Color(0xFF024A8D),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ),
    );
  },
)
         )
         
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 2),
            child: Text(
              "Working Hours",
              style: const TextStyle(
                  fontSize: 20.0,
                  color: const Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    height: 20,
                  ),
                  
                  Row(
                    children: [
                      const SizedBox(width: 2, height: 2,),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 35, bottom: 5),
                              child: Text(
                                "${offerDetails[0]["JobTitle"]}",
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              "By ${offerDetails[0]["CompanyName"]}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.050,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            
                          ],
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
                    height: screenHeight * 0.82,
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
                          child: ListView(
                            
                            padding: const EdgeInsets.all(5),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "Job Description",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: const Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["JobDescription"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: const Color(0xFF024A8D),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 2),
                                child: Text(
                                  "Job Category",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: const Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["CategoryName"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: const Color(0xFF024A8D),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 2),
                                child: Text(
                                  "Employment Type",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: const Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["EmploymentType"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: const Color(0xFF024A8D),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 2),
                                child: Text(
                                  "Job Address",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: const Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["JobAddress"]}"
                                "${offerDetails[0]["CityName"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: const Color(0xFF024A8D),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 2),
                                child: Text(
                                  "Salary Range",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: const Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["MinSalary"]} - ${offerDetails[0]["MaxSalary"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: const Color(0xFF024A8D),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 2),
                                child: Text(
                                  "Posted Day",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: const Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["Date"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: const Color(0xFF024A8D),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              startingDateCheck(),
                              workingDaysCheck(),
                              workingHoursCheck(),
                              notesCheck(),
                              renderQualifications(),
                              renderExpriences(),
                              renderSkills()
                            ],
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

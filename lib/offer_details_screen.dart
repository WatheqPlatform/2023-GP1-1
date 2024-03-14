// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Interviews/interview_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/error_messages.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class JobOfferDetailScreen extends StatefulWidget {
  final String offerID;
  final String email;

  const JobOfferDetailScreen({
    super.key,
    required this.offerID,
    required this.email,
  });

  @override
  State<JobOfferDetailScreen> createState() => _StateJobOfferDetailScreen();
}

class AnimatedButton extends StatelessWidget {
  final VoidCallback pressEvent;
  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final Color borderColor;
  final Widget child;

  const AnimatedButton({
    Key? key,
    required this.pressEvent,
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.borderColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressEvent,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor),
        ),
        child: child,
      ),
    );
  }
}

class _StateJobOfferDetailScreen extends State<JobOfferDetailScreen> {
  List offerDetails = [];

  List profileList = [];

  bool empty = true;

  bool hasApplied = false;
  bool isAccepted = false;
  bool isRejected = false;

  bool isClosed = false;

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
        if (offerDetails[0]["Status"] == "Closed") {
          isClosed = true;
        }
        empty = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    checkApplication();
    fetchCompanyInfo();
  }

  Future checkApplication() async {
    try {
      var response = await http.post(
        Uri.parse(Connection.checkApplication),
        body: {
          "email": widget.email,
          "OfferID": widget.offerID,
        },
      );
      if (response.statusCode == 200) {
        // communication is succefull
        var resBodyOfCheck = jsonDecode(response.body.trim());

        setState(() {
          hasApplied = resBodyOfCheck['applied'];
          isAccepted = resBodyOfCheck['accepted'];
          isRejected = resBodyOfCheck['rejected'];
        });
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMessage.show(context, "Error", 18, "Please check your connection.",
            ContentType.failure, const Color.fromARGB(255, 209, 24, 24));
      }
    }
  }

  Future apply() async {
    try {
      var response = await http.post(
        Uri.parse(Connection.apply),
        body: {"email": widget.email, "offerId": widget.offerID},
      );

      if (response.statusCode == 200) {
        // communication is succefull
        var resBodyOfApply = jsonDecode(response.body.trim());

        if (resBodyOfApply == 1) {
          setState(() {
            hasApplied = true;
          });
          if (context.mounted) {
            ErrorMessage.show(
                context,
                "Success",
                18,
                "You have successfully applied to the job offer.",
                ContentType.failure,
                const Color.fromARGB(255, 15, 152, 20));
          }
        } else {
          if (context.mounted) {
            ErrorMessage.show(
                context,
                "Error",
                18,
                "Please fill your CV information to apply to job offer.",
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

  void cancelApplication() async {
    var res = await http.post(Uri.parse(Connection.cancelApplication),
        body: {'email': widget.email, "OfferID": widget.offerID});

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body.trim());
      if (resBody == 1) {
        setState(() {
          hasApplied = false;
        });
        if (context.mounted) {
          ErrorMessage.show(
            context,
            "Success",
            18,
            "The application has been cancelled successfully.",
            ContentType.success,
            const Color.fromARGB(255, 15, 152, 20),
          );
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
    } else {
      if (context.mounted) {
        ErrorMessage.show(context, "Error", 18, "Please check your connection.",
            ContentType.failure, const Color.fromARGB(255, 209, 24, 24));
      }
    }
  }

  //checking optional fields value

  Widget startingDateCheck() {
    if (offerDetails[0]["StartingDate"] != null &&
        offerDetails[0]["StartingDate"] != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Starting Date",
              style: TextStyle(
                  fontSize: 19.0,
                  fontFamily: 'poppins',
                  color: Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "${offerDetails[0]["StartingDate"]}",
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 37, 42, 74),
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
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
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Working Days",
              style: TextStyle(
                  fontSize: 19.0,
                  color: Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "\u{25AA}  ${offerDetails[0]["WorkingDays"]}"
                .capitalizeEach()
                .replaceAll(", ", "\n\u{25AA}  "),
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 37, 42, 74),
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
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
        offerDetails[0]["WorkingHours"] != "" &&
        int.parse(offerDetails[0]["WorkingHours"]) != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Working Hours",
              style: TextStyle(
                fontSize: 19.0,
                color: Color(0xFF024A8D),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "${offerDetails[0]["WorkingHours"]}h Per Day",
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 37, 42, 74),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.justify,
          ),
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
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Required Skills",
              style: TextStyle(
                  fontSize: 19.0,
                  color: Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "${offerDetails[0]['skills']}"
                .replaceAll("[", "\u{25AA}  ")
                .replaceAll("]", "")
                .replaceAll(", ", "\n\u{25AA}  "),
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 37, 42, 74),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.justify,
          )
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
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Required Qualifications",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "${offerDetails[0]['qualifications']}"
                .replaceAll("[", "")
                .replaceAll("]", "")
                .replaceAll("{", "\u{25AA} ")
                .replaceAll("}", " Degree\n")
                .replaceAll("Field:", "")
                .replaceAll(", ", "\n")
                .replaceAll("DegreeLevel:", "  "),
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 37, 42, 74),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
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
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Required Experiences",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "${offerDetails[0]['experiences']}"
                .replaceAll("[", "")
                .replaceAll("]", "")
                .replaceAll("{", "")
                .replaceAll("}", " Years\n")
                .replaceAll("Description: ", "\u{25AA}  ")
                .replaceAll("ExperienceField", "\u{25AA}  Field")
                .replaceAll("JobTitle", "\u{25AA}  Job Title")
                .replaceAll(
                    "YearsOfExperience", "\u{25AA}  Years Of Experience")
                .replaceAll(", ", " \n"),
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 37, 42, 74),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
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
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 1),
            child: Text(
              "Additional Notes",
              style: TextStyle(
                  fontSize: 19.0,
                  color: Color(0xFF024A8D),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            "${offerDetails[0]["AdditionalNotes"]}"
                .replaceAll(RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n'),
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 37, 42, 74),
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Future fetchCompanyInfo() async {
    var res = await http.post(
      Uri.parse(Connection.getProfile),
      body: {"OfferID": widget.offerID},
    );

    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);
      print(red);

      setState(() {
        profileList = red.toList();
      });
    }
  }

  void showCompanyInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double bottomSheetMinHeight = screenHeight * 0.565;

        return Container(
          height: bottomSheetMinHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  right: 8,
                  left: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    if (profileList
                        .isNotEmpty) // Conditionally render the title
                      Expanded(
                        child: Text(
                          offerDetails.isNotEmpty
                              ? "${offerDetails[0]["CompanyName"]}"
                              : 'Company Name',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF024A8D)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(width: 48), // Placeholder for symmetry
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 25,
                  ),
                  child: profileList.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildProfileInfoTile(
                                "About Us", profileList[0]["Description"]),
                            const SizedBox(height: 20),
                            const Text(
                              "Contact Information",
                              style: TextStyle(
                                  color: Color(0xFF024A8D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            // For items without URLs
                            buildContactInfoItem(Icons.location_on_outlined,
                                profileList[0]["Location"], null),
                            buildContactInfoItem(Icons.email_outlined,
                                profileList[0]["Email"], null),
                            buildContactInfoItem(Icons.phone_outlined,
                                profileList[0]["Phone"], null),

                            buildContactInfoItem(
                                FontAwesomeIcons.linkedinIn,
                                profileList[0]["Linkedin"],
                                "https://" +
                                    profileList[0]["Linkedin"].toString()),
                            buildContactInfoItem(
                                FontAwesomeIcons.xTwitter,
                                profileList[0]["Twitter"],
                                "https://" +
                                    profileList[0]["Twitter"].toString()),
                            buildContactInfoItem(
                                FontAwesomeIcons.link,
                                profileList[0]["Link"],
                                "https://" + profileList[0]["Link"].toString()),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: bottomSheetMinHeight * 0.35),
                          child: const Text(
                            "No company information available.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildProfileInfoTile(String title, dynamic value) {
    return value != null && value.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xFF024A8D),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 37, 42, 74)),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
            ],
          )
        : SizedBox.shrink();
  }

  Widget buildContactInfoItem(
    IconData icon,
    String? content,
    String? url,
  ) {
    if (content == null || content.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 37, 42, 74)),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                url != null ? _launchUrl(url) : null;
              },
              child: Text(
                content,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 37, 42, 74)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: empty
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF024A8D),
              ),
            )
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
                      const SizedBox(
                        width: 2,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 40,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 1),
                        child: Text(
                          "${offerDetails[0]["JobTitle"]}".capitalizeEach(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 30,
                          child: IconButton(
                            icon: const Icon(
                              Icons.account_circle_rounded,
                              size: 30,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: GestureDetector(
                            onTap: () => showCompanyInfoBottomSheet(context),
                            child: Text(
                              "   ${offerDetails[0]["CompanyName"]}"
                                  .capitalizeEach()
                                  .replaceAll(
                                      RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n'),
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    height: screenHeight * 0.833,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 38,
                        ),

                        if (isAccepted)
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 5.0,
                              bottom: 1,
                            ),
                            child: Text(
                              "Congratulations, you are accepted!",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16, // Adjust the font size as needed
                              ),
                            ),
                          )
                        else if (isClosed)
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 5.0,
                              bottom: 1,
                            ),
                            child: Text(
                              "This job offer is closed.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16, // Adjust the font size as needed
                              ),
                            ),
                          )
                        else if (isRejected)
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 5.0,
                              bottom: 1,
                            ),
                            child: Text(
                              "Sorry, your application is rejected.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16, // Adjust the font size as needed
                              ),
                            ),
                          ),

                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              bottom: 5,
                            ),
                            children: [
                              if (!isClosed && !isAccepted && !isRejected)
                                Text(
                                  "Posted on ${offerDetails[0]["Date"]}",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromARGB(169, 158, 158, 158),
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.left,
                                ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 1),
                                child: Text(
                                  "Job Description",
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      color: Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["JobDescription"]}"
                                    .replaceAll(
                                        RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'),
                                        '\n'),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 37, 42, 74),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 1),
                                child: Text(
                                  "Industry",
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      color: Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["CategoryName"]}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 37, 42, 74),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 1),
                                child: Text(
                                  "Type",
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      color: Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["EmploymentType"]}"
                                    .capitalizeEach(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 37, 42, 74),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 1),
                                child: Text(
                                  "Location",
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      color: Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                "${offerDetails[0]["CityName"]}, "
                                        "${offerDetails[0]["JobAddress"]} "
                                    .capitalizeEach()
                                    .replaceAll(
                                        RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'),
                                        '\n'),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 37, 42, 74),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 1),
                                child: Text(
                                  int.parse(offerDetails[0]["MinSalary"]
                                              .toString()) ==
                                          int.parse(offerDetails[0]["MaxSalary"]
                                              .toString())
                                      ? "Salary"
                                      : "Salary Range",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Color(0xFF024A8D),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Text(
                                int.parse(offerDetails[0]["MinSalary"]
                                            .toString()) !=
                                        int.parse(offerDetails[0]["MaxSalary"]
                                            .toString())
                                    ? "${offerDetails[0]["MinSalary"]}SAR - ${offerDetails[0]["MaxSalary"]}SAR"
                                    : "${offerDetails[0]["MinSalary"]}SAR",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 37, 42, 74),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                              ),
                              startingDateCheck(),
                              workingDaysCheck(),
                              workingHoursCheck(),
                              renderSkills(),
                              renderExpriences(),
                              renderQualifications(),
                              notesCheck(),
                            ],
                          ),
                        ),
                        //Buttons
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            children: [
                              if (isAccepted) ...[
                                ElevatedButton(
                                  onPressed: null, // Disabled
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.grey, // Gray color when disabled
                                    fixedSize: Size(screenWidth * 0.93,
                                        screenHeight * 0.056),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    "Apply",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () {
                                    // Navigate to InterviewScreen using Get.to
                                    Get.to(() => Interviews(
                                          offerID: widget.offerID,
                                          email: widget.email,
                                        ));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 1.5,
                                      color: Color(0xFF024A8D),
                                    ),
                                    fixedSize: Size(screenWidth * 0.93,
                                        screenHeight * 0.052),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "Mock Interview",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF024A8D),
                                    ),
                                  ),
                                ),
                              ] else if (isClosed || isRejected) ...[
                                ElevatedButton(
                                  onPressed: null, // Disabled
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    fixedSize: Size(screenWidth * 0.93,
                                        screenHeight * 0.056),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    "Apply",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: null, // Disabled
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 1.5,
                                      color: Colors.grey,
                                    ),
                                    fixedSize: Size(
                                      screenWidth * 0.93,
                                      screenHeight * 0.052,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "Mock Interview",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ] else if (!hasApplied) ...[
                                ElevatedButton(
                                  onPressed: () {
                                    apply();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF024A8D),
                                    fixedSize: Size(screenWidth * 0.93,
                                        screenHeight * 0.056),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    "Apply",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () {
                                    // Navigate to InterviewScreen using Get.to
                                    Get.to(() => Interviews(
                                          offerID: widget.offerID,
                                          email: widget.email,
                                        ));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 1.5,
                                      color: Color(0xFF024A8D),
                                    ),
                                    fixedSize: Size(screenWidth * 0.93,
                                        screenHeight * 0.052),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "Mock Interview",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF024A8D),
                                    ),
                                  ),
                                ),
                              ] else if (!isAccepted) ...[
                                AnimatedButton(
                                  pressEvent: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.topSlide,
                                      showCloseIcon: true,
                                      title: "Cancel Application",
                                      desc:
                                          'Are you sure you want to cancel your application?',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        cancelApplication();
                                      },
                                      btnCancelColor: Colors.grey,
                                      btnOkColor: Color(0xFFD93D46),
                                      btnCancelText: 'NO',
                                      btnOkText: 'YES',
                                    ).show();
                                  },
                                  height: screenHeight * 0.052,
                                  width: screenWidth * 0.93,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  borderColor: Color.fromARGB(255, 209, 24, 24),
                                  child: Center(
                                    child: Text(
                                      "Cancel Application",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 209, 24, 24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () {
                                    // Navigate to InterviewScreen using Get.to
                                    Get.to(() => Interviews(
                                          offerID: widget.offerID,
                                          email: widget.email,
                                        ));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 1.5,
                                      color: Color(0xFF024A8D),
                                    ),
                                    fixedSize: Size(screenWidth * 0.93,
                                        screenHeight * 0.052),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "Mock Interview",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF024A8D),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

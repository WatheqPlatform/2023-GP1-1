// ignore_for_file: library_private_types_in_public_api

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:watheq/Authentication/login_screen.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/offers_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/Applications_Screen.dart';
import 'package:watheq/profile_screen.dart';

import '../error_messages.dart';
import 'controller/form_controller.dart';


class ExperiencesScreen extends StatefulWidget {
  final String email;
  final VoidCallback onBack;
  ExperiencesScreen({super.key, required this.onBack, required this.email});
  final FormController formController = Get.find( tag: 'form-control' );
  @override
  _ExperiencesScreenState createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen> {
  List<TextEditingController> jobTitleControllers=[TextEditingController()];
  List<TextEditingController> companyNameControllers=[TextEditingController()];
  List<TextEditingController> startDatesController=[TextEditingController()];
  List<TextEditingController> endDatesController=[TextEditingController()];
  List<TextEditingController> experienceIndustryControllers=[TextEditingController()];
  int steps = 1;
  List<String> fields = [];
  List <dynamic> fieldsWithId = [];
  String? validateCV(Map<String, dynamic> data) {
    List<String> requiredFieldsCV = ['firstName', 'lastName', 'phoneNumber', 'contactEmail', 'seekerEmail', 'summary', 'city'];

    for (String field in requiredFieldsCV) {
      if (data[field] == null || data[field].toString().isEmpty) {
        return "Missing or empty field for CV: $field";
      }
    }

    if (data['awards'] != null && data['awards'] is List) {
      for (Map<String, dynamic> award in data['awards']) {
        List<String> requiredFieldsAward = ['awardName', 'issuedBy', 'date'];

        for (String field in requiredFieldsAward) {
          if (award[field] == null || award[field].toString().isEmpty) {
            return "Missing or empty field in awards: $field";
          }
        }
      }
    }

    if (data['qualifications'] != null && data['qualifications'] is List) {
      for (Map<String, dynamic> qualification in data['qualifications']) {
        List<String> requiredFieldsQualification = ['DegreeLevel', 'Field', 'FieldFlag', 'StartDate', 'EndDate', 'UniversityName'];

        for (String field in requiredFieldsQualification) {
          if (qualification[field] == null || qualification[field].toString().isEmpty) {
            return "Missing or empty field in qualifications: $field";
          }
        }
        if (qualification['StartDate'] != null && qualification['EndDate'] != null) {
          DateTime startDate = intl.DateFormat('yyyy/MM/dd').parse(qualification['StartDate']);
          DateTime endDate = intl.DateFormat('yyyy/MM/dd').parse(qualification['EndDate']);

          if (startDate.isAfter(endDate)) {
            return "StartDate must be before EndDate in qualifications";
          }
        }
      }
    }
    if (data['projects'] != null && data['projects'] is List) {
      for (Map<String, dynamic> project in data['projects']) {
        List<String> requiredFieldsProject = ['ProjectName', 'Description', 'Date'];

        for (String field in requiredFieldsProject) {
          if (project[field] == null || project[field].toString().isEmpty) {
            return "Missing or empty field in projects: $field";
          }
        }

      }
    }
    if (data['experiences'] != null && data['experiences'] is List) {
      for (Map<String, dynamic> experience in data['experiences']) {
        List<String> requiredFieldsExperience = ['CategoryID', 'JobTitle', 'CompanyName', 'StartDate', 'EndDate'];

        for (String field in requiredFieldsExperience) {
          if (experience[field] == null || experience[field].toString().isEmpty) {
            return "Missing or empty field in experiences: $field";
          }
        }
        if (experience['StartDate'] != null && experience['EndDate'] != null) {
          DateTime startDate = intl.DateFormat('yyyy/MM/dd').parse(experience['StartDate']);
          DateTime endDate = intl.DateFormat('yyyy/MM/dd').parse(experience['EndDate']);

          if (startDate.isAfter(endDate)) {
            return "StartDate must be before EndDate in experiences";
          }
        }
      }
    }


    return null;
  }

  addCV(dynamic body) async {
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
      print(body);
      String jsonString = json.encode(body);
      print(jsonString);
      var response = await http.post(
        Uri.parse(Connection.createCv),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );
      widget.formController.reset();
      Get.off(ProfileScreen(email: widget.email));

    } catch (e) {
      print(e);
    }
  }

  List<Widget> buildsteps() {
    if (fieldsWithId.length == 0 || fields.length == 0) {
      return [];
    }
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String category = fields[0], jobTitle = '', company = '', startDate = '', endDate = '';

      if (widget.formController.formData['experiences'].length >= i) {
        final experience = widget.formController.formData['experiences'][i-1];

        category = fieldsWithId.where((element) => element['CategoryID'] == experience['CategoryID'].toString()).first['CategoryName'];
        jobTitle = experience['JobTitle'];
        company = experience['CompanyName'];
        startDate = experience['StartDate'];
        endDate = experience['EndDate'];
      }

      jobTitleControllers.add(TextEditingController(text: jobTitle));
      companyNameControllers.add(TextEditingController(text: company));
      startDatesController.add(TextEditingController(text: startDate));
      endDatesController.add(TextEditingController(text: endDate));
      experienceIndustryControllers.add(TextEditingController(text: category));
      l.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience $i',
            style: TextStyle(
                color: Color(0xFF085399), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40,),
          if(fields.length > 0) Column(
            children: [
              Row(
                children: [
                  Text('Experience Industry',
                    style: const TextStyle(color: Color(0xFF085399)), // Label color
                  ),
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red),
                  ),

                ],
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
                    horizontal:  8.0,
                    vertical:  0.012,
                  ),
                ),
                value: experienceIndustryControllers[i].text,

                onChanged: (String? newValue) {
                  setState(() {
                    experienceIndustryControllers[i].text = newValue!;
                  });
                },
                items: fields.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),
          SizedBox(height: 5,),
          RequiredFieldWidget(
            label: 'Job Title',
            keyName: 'jobTitle',
            controller: jobTitleControllers[i],
          ),
          // Repeat for other fields
          RequiredFieldWidget(
            label: 'Company Name',
            keyName: 'companyName',
            controller: companyNameControllers[i],
          ),
          DateButton(label: 'Start Date',dateController: startDatesController[i],),
          DateButton(label: 'End Date',dateController: endDatesController[i],),
          i!=1? IconButton(
              onPressed: () {
                int index=i;
                print(steps.toString());
                setState(() {
                  steps--;
                  jobTitleControllers.removeAt(index-1);
                  companyNameControllers.removeAt(index-1);
                  l.removeAt(index-1);
                });
              },
              icon: Icon(
                Icons.remove_circle_outline,
                color:Colors.red,
              )):SizedBox(),
          i==steps? IconButton(
              onPressed: () {
                steps++;
                print(steps.toString());
                setState(() {
                });
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Color(0xFF085399),
              )):SizedBox(),
        ],
      ));
    }
    return l;
  }
  @override
  void initState() {
    steps = widget.formController.formData['experiences'].length > 0 ? widget.formController.formData['experiences'].length : 1;
    super.initState();
    fetchCategories().then((val) {
      fields = List<String>.from(val.map((e) {return e['CategoryName']; }));
      fieldsWithId = List<dynamic>.from(val.map((e) {return e;} ));
      setState(() {

      });
    });
  }
  dynamic fetchCategories() async {
    final response = await http.get(Uri.parse(Connection.getCategories));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load Categories');
    }
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
                    "Experiences Screen",
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
            Expanded(child:SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 30,
                ),
                height: screenHeight * 0.86,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: Form(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight*0.658,
                        child: ListView(children: buildsteps()),
                      ),
                      SizedBox(height: 10,),
                      // Next button aligned to the bottom right
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  widget.onBack();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFd4d4d4), // ##d4d4d4
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                ),
                                icon: Icon(Icons
                                    .arrow_back), // Change the icon as needed
                                label: Text('Back'),
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  widget.formController.formData['experiences'] = [];
                                  for (int i = 1; i <= steps; i++) {
                                    if (jobTitleControllers[i].text.isNotEmpty) {
                                      widget.formController.addExperience({
                                        'CategoryID': fieldsWithId.where((element) => element['CategoryName'] == experienceIndustryControllers[i].text).first['CategoryID'],
                                        'JobTitle': jobTitleControllers[i].text,
                                        'CompanyName': companyNameControllers[i].text,
                                        'StartDate': startDatesController[i].text,
                                        'EndDate': endDatesController[i].text,
                                    });
                                    }
                                  }
                                  final body = widget.formController.formData.value;
                                  body['seekerEmail'] = widget.email;
                                  String? validationError = validateCV(body);
                                  if (validationError == null) {
                                      addCV(body);
                                  } else {
                                    return ErrorMessage.show(
                                        context,
                                        "Error",
                                        14,
                                        validationError,
                                        ContentType.failure,
                                        const Color.fromARGB(255, 209, 24, 24));
                                  }
                                  //widget.onNext();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF085399), // #085399
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                ),
                                icon: Icon(Icons
                                    .arrow_back), // Change the icon as needed
                                label: Text('Create'),
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}

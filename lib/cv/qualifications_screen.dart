// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

import '../profile_screen.dart';
import 'controller/form_controller.dart';

class QualificationsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final email;
  QualificationsScreen({super.key, required this.isEdit,  required this.formKey, required this.onNext, required this.onBack, required this.email});
  final FormController formController = Get.find( tag: 'form-control' );
  @override
  _QualificationsScreenState createState() => _QualificationsScreenState();
}

class _QualificationsScreenState extends State<QualificationsScreen> {
  List<TextEditingController> degreeLevelControllers=[TextEditingController()];
  List<TextEditingController> degreeFieldControllers=[TextEditingController()];
  List<TextEditingController> universityControllers=[TextEditingController()];
  List<TextEditingController> otherContrllers=[TextEditingController()];
  List<TextEditingController> startDatesController=[TextEditingController()];
  List<TextEditingController> endDatesController=[TextEditingController()];
  List<String> fields =[] ;
  int steps = 1;
  List<Widget> buildsteps() {
    if (fields.length == 0) {
      return [];
    }
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String level = "Pre-high school", field = fields[0], other = "", sDate = "", endDate ="", uName = "";
      if (widget.formController.formData['qualifications'].length >= i) {
        level = widget.formController.formData['qualifications'][i-1]['DegreeLevel'];
        sDate = widget.formController.formData['qualifications'][i-1]['StartDate'];
        endDate = widget.formController.formData['qualifications'][i-1]['EndDate'];
        uName = widget.formController.formData['qualifications'][i-1]['UniversityName'];
        if (widget.formController.formData['qualifications'][i-1]['FieldFlag'] == 0) {
          field = widget.formController.formData['qualifications'][i-1]['Field'];
        }
        else {
          other = widget.formController.formData['qualifications'][i-1]['Field'];
          field = 'other';
        }
      }
      degreeLevelControllers.add(TextEditingController(text: level));
      degreeFieldControllers.add(TextEditingController(text: field));
      otherContrllers.add(TextEditingController(text: other));
      startDatesController.add(TextEditingController(text: sDate));
      endDatesController.add(TextEditingController(text: endDate));
      universityControllers.add(TextEditingController(text: uName));
      l.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qualification $i',
            style: TextStyle(
                color: Color(0xFF085399), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text('Degree Level',
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
          value: degreeLevelControllers[i].text,
          onChanged: (String? newValue) {
            if (newValue != null)
              degreeLevelControllers[i].text = newValue;

            setState(() {

            });
          },
          items: [
            'Pre-high school',
            'High School',
            'Diploma',
            'Bachelor',
            'Master',
            'Doctorate',
            'Post Doctorate',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
          SizedBox(height: 20,),
          if (fields.length > 0) Visibility(
            visible: degreeLevelControllers[i].text != 'Pre-high school',
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Degree Field',
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
                  value: degreeFieldControllers[i].text,
                  onChanged: (String? newValue) {
                    setState(() {
                      degreeFieldControllers[i].text = newValue!;
                    });
                  },
                  items: fields.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                RequiredFieldWidget(label: 'University Name', keyName: 'u-name', controller: universityControllers[i])
              ],
            ),
          ) ,
          // Repeat for other fields
          SizedBox(height: 20,),
          Visibility(child: RequiredFieldWidget(label: 'Custom Field', keyName: 'field', controller: otherContrllers[i]),visible: degreeFieldControllers[i].text == 'other',),
          DateButton(label: 'Start Date',dateController: startDatesController[i],),
          DateButton(label: 'End Date',dateController: endDatesController[i],),
          i!=1? IconButton(
              onPressed: () {
                int index=i;
                setState(() {
                  steps--;
                  degreeLevelControllers.removeAt(index-1);
                  degreeFieldControllers.removeAt(index-1);
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
    super.initState();
    steps = widget.formController.formData['qualifications'].length > 0 ? widget.formController.formData['qualifications'].length : 1;
    fetchCategories().then((val) {
      fields = List<String>.from(val.map((e) {return e['CategoryName']; }));
      fields.add('other');
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
                    "Qualifications Screen",
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
              child:SingleChildScrollView(
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
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight*0.6,
                        child: ListView(children: buildsteps()),
                      ),
                      SizedBox(height: 10,),
                      // Next button aligned to the bottom right
                      Column(
                        children: [
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
                                      widget.formController.formData['qualifications'] = [];
                                        for (int i = 1; i <= steps; i++) {
                                          if (degreeLevelControllers[i].text.isNotEmpty) {
                                            widget.formController.addQualification(
                                                {
                                                  'DegreeLevel': degreeLevelControllers[i].text,
                                                  'Field': degreeFieldControllers[i].text == 'other' ? otherContrllers[i].text : degreeFieldControllers[i].text,
                                                  'FieldFlag': degreeFieldControllers[i].text == 'other' ? 1 : 0,
                                                  'StartDate': startDatesController[i].text,
                                                  'EndDate': endDatesController[i].text,
                                                  'UniversityName': universityControllers[i].text

                                                });
                                          }
                                        }
                                        widget.onNext();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF085399), // #085399
                                      padding: EdgeInsets.symmetric(horizontal: 40),
                                    ),
                                    icon: Icon(Icons
                                        .arrow_back), // Change the icon as needed
                                    label: Text('Next'),
                                  ),
                                )
                              ]),
                          ElevatedButton(
                            onPressed: () {
                              // Show confirmation dialog
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Are you sure you want to cancel?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.off(ProfileScreen(email: widget.email));
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent, // Set the color to grey
                              padding: EdgeInsets.symmetric(horizontal: 100),
                            ),
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
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

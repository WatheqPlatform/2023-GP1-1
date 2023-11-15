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

class ProjectsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final email;
  ProjectsScreen({super.key, required this.isEdit,  required this.formKey, required this.onNext, required this.onBack, required this.email});
  final FormController formController = Get.find( tag: 'form-control' );
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<TextEditingController> projectNameControllers=[TextEditingController()];
  List<TextEditingController> descriptionControllers=[TextEditingController()];
  List<TextEditingController> datesControllers=[TextEditingController()];
  int steps = 1;
  List<Widget> buildsteps() {
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String projectName = "", description = "", date = "";
      if (widget.formController.formData['projects'].length >= i) {
        projectName = widget.formController.formData['projects'][i-1]['ProjectName'];
        description = widget.formController.formData['projects'][i-1]['Description'];
        date = widget.formController.formData['projects'][i-1]['Date'];
      }
      projectNameControllers.add(TextEditingController(text: projectName));
      descriptionControllers.add(TextEditingController(text: description));
      datesControllers.add(TextEditingController(text: date));
      l.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project $i',
            style: TextStyle(
                color: Color(0xFF085399), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5,),
          RequiredFieldWidget(
            label: 'Project Name',
            keyName: 'projectName',
            controller: projectNameControllers[i],
          ),
          // Repeat for other fields
          RequiredFieldWidget(
            label: 'Description',
            keyName: 'description',
            controller: descriptionControllers[i],
          ),
          DateButton(label: 'Date',dateController: datesControllers[i],),
          i!=1? IconButton(
              onPressed: () {
                int index=i;
                print(steps.toString());
                setState(() {
                  steps--;
                  projectNameControllers.removeAt(index-1);
                  descriptionControllers.removeAt(index-1);
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
    steps = widget.formController.formData['projects'].length > 0 ? widget.formController.formData['projects'].length : 1;

    super.initState();
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
                    "Projects Screen",
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
                                      widget.formController.formData['projects'] = [];
                                      for (int i = 1; i <= steps; i++) {
                                        if (projectNameControllers[i].text.isNotEmpty) {
                                          widget.formController.addProject({
                                          'ProjectName': projectNameControllers[i].text,
                                          'Description': descriptionControllers[i].text,
                                          'Date': datesControllers[i].text,
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

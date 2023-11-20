

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
  final goToPage;
  ProjectsScreen({super.key, required this.isEdit,  required this.formKey, required this.onNext, required this.onBack, required this.email, required this.goToPage});
  final FormController formController = Get.find( tag: 'form-control' );
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<TextEditingController> projectNameControllers=[TextEditingController()];
  List<TextEditingController> descriptionControllers=[TextEditingController()];
  List<TextEditingController> datesControllers=[TextEditingController()];
  int steps = -1;
  int lastSteps = -1;
  List<Widget> cachedSteps = [];
  Widget buildStepItem(int i) {
    return Column(
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
          hideStar: true,
          controller: projectNameControllers[i],
        ),
        // Repeat for other fields
        RequiredFieldWidget(
          label: 'Description',
          keyName: 'description',
          controller: descriptionControllers[i],
          starColor: Colors.green,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
        ),
        DateButton(label: 'Completion Date',dateController: datesControllers[i],starColor: Colors.green,),
      ],
    );
  }
  List<Widget> buildsteps() {
    List<Widget> l = [];
     projectNameControllers=[TextEditingController()];
     descriptionControllers=[TextEditingController()];
     datesControllers=[TextEditingController()];
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
      l.add(buildStepItem(i));
    }
    return l;
  }
  List<Widget> addOrGetCachedSteps() {
    if (steps == lastSteps) {
      return cachedSteps;
    }

    if (steps > lastSteps) {
      lastSteps = steps;
      datesControllers.add(TextEditingController());
      projectNameControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
      cachedSteps.add(buildStepItem(steps));
      return cachedSteps;
    }
    lastSteps = steps;
    datesControllers.removeLast();
    projectNameControllers.removeLast();
    descriptionControllers.removeLast();
    cachedSteps.removeLast();
    return cachedSteps;
  }
  @override
  void initState() {
    steps = widget.formController.formData['projects'].length > 0 ? widget.formController.formData['projects'].length : 1;
    lastSteps = steps;
    cachedSteps = buildsteps();
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
                const SizedBox(width: 2),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,    builder: (BuildContext context) {
                      return AlertDialog(        title: Text('Confirmation'),
                        content: Text(            'Are you sure you want to cancel?'),
                        actions: [          TextButton(
                          onPressed: () {              Navigator.of(context)
                              .pop();            },
                          child: Text('No'),          ),
                          TextButton(            onPressed: () {
                            Get.offAll(ProfileScreen(email: widget.email));            },
                            child: Text('Yes'),          ),
                        ],      );
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 1),
                  child: Text(
                    "Projects",
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
                      Theme(
                        data: ThemeData(  shadowColor: const Color.fromARGB(0, 255, 255, 255),backgroundColor: Colors.transparent,
                            canvasColor: Colors.transparent,
                            colorScheme: ColorScheme.light(
                              primary: Color(0xFF085399),

                            )),
                        child: SizedBox(child:Stepper(

                          steps: const [
                            Step(title: SizedBox(width: 0,), content: SizedBox(), isActive: true,   ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true,  ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true, ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true, ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: false, ),

                          ],
                          type: StepperType.horizontal,

                        ),height: 75 ,),
                      ),
                      SizedBox(
                        height: screenHeight*0.57,
                        child: ListView(children: [
                          ...addOrGetCachedSteps(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                steps != 1 ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      steps--;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                ) :SizedBox(width: 0,height: 0,),
                                IconButton(
                                  onPressed: () {
                                    steps++;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFF085399),
                                  ),
                                )
                              ])
                        ]),
                      ),
                      SizedBox(height: 10,),

                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(

                                  onPressed: () {
                                    widget.onBack();

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  icon: Icon(Icons.arrow_back),
                                  label: Text('Back'),
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
                                      primary: Color(0xFF085399),
                                      padding: EdgeInsets.symmetric(horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                    ),
                                    icon: Icon(Icons
                                        .arrow_back),
                                    label: Text('Next'),
                                  ),
                                )
                              ]),
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
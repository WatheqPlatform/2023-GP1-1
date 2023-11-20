
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
import 'package:watheq/profile_screen.dart';

import 'controller/form_controller.dart';

class AwardsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final email;
  final VoidCallback onBack;
  final goToPage;

  AwardsScreen(
      {super.key,
      required this.isEdit,
      required this.formKey,
      required this.onNext, required this.onBack, required this.email, required this.goToPage});

  @override
  _AwardsScreenState createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  @override
  void initState() {
    super.initState();
    steps = formController.formData['awards'].length> 0 ? formController.formData['awards'].length :  1;
    lastSteps = steps;
    cachedSteps = buildsteps();
  }
  final FormController formController = Get.find<FormController>(tag: 'form-control');
  List<TextEditingController> awardNameControllers=[TextEditingController()];
  List<TextEditingController> issuedByControllers=[TextEditingController()];
  List<TextEditingController> datesController=[TextEditingController()];
  late int steps = -1;
  late int lastSteps = -1;
  List<Widget> cachedSteps = [];

  Widget buildStepItem (int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Award $i',
          style: TextStyle(
              color: Color(0xFF085399), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5,),
        RequiredFieldWidget(
          label: 'Award Name',
          controller: awardNameControllers[i],
          hideStar: true,
        ),

        DateButton(label: 'Date',dateController: datesController[i], starColor: Colors.green,lastDate: DateTime.now(),),
        RequiredFieldWidget(
          label: 'Issued By',
          controller: issuedByControllers[i],
          starColor: Colors.green,
        ),

      ],
    );
  }
  List<Widget> buildsteps() {
    if (steps == -1) {
      return [];
    }
    awardNameControllers=[TextEditingController()];
    issuedByControllers=[TextEditingController()];
    datesController=[TextEditingController()];
    List<Widget> l = [];
    final x = formController.formData.value['awards'];

    for (int i = 1; i <= steps; i++) {
      String? awardName = null, issuedBy = null, date = null;

      if (x.length >= i) {
        awardName = x[i-1]['awardName'];
        issuedBy = x[i-1]['issuedBy'];
        date = x[i-1]['date'];
        awardNameControllers.add(TextEditingController(text: awardName));
        issuedByControllers.add(TextEditingController(text: issuedBy));
        datesController.add(TextEditingController(text: date));
      }
      else {

        awardNameControllers.add(TextEditingController());
        issuedByControllers.add(TextEditingController());
        datesController.add(TextEditingController());
      }

      l.add(buildStepItem(i));
    }
    return l;
  }
  List<Widget> addOrGetCachedSteps() {
    if (lastSteps == steps) return cachedSteps;

    if (steps > lastSteps) {
      lastSteps = steps;
      awardNameControllers.add(TextEditingController());
      issuedByControllers.add(TextEditingController());
      datesController.add(TextEditingController());
      cachedSteps.add(
          buildStepItem(steps)
      );

      return cachedSteps;
    }
    lastSteps = steps;
    awardNameControllers.removeLast();
    issuedByControllers.removeLast();
    datesController.removeLast();
    cachedSteps.removeLast();
    return cachedSteps;

  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
                    "Awards",
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
              child: SingleChildScrollView(
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
                      Step(title: SizedBox(), content: SizedBox(), isActive: false, ),
                      Step(title: SizedBox(), content: SizedBox(), isActive: false, ),
                      Step(title: SizedBox(), content: SizedBox(), isActive: false, ),

                    ],
                    type: StepperType.horizontal,

                  ),height: 75 ,),
                ),

                        SizedBox(
                          height: screenHeight*0.6,
                          child: ListView(children: [...addOrGetCachedSteps(), Row(
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
                            ]),
                        ])),

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
                                        widget.formKey.currentState!.save();
                                        formController.formData.value['awards'] = [];
                                        for( int i=1;i<=steps;i++) {

                                          final data = {
                                            'awardName': awardNameControllers[i].text,
                                            'issuedBy': issuedByControllers[i].text,
                                            'date': datesController[i].text
                                          };
                                          if (awardNameControllers[i].text.isNotEmpty) {
                                            formController.addAward(data);
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

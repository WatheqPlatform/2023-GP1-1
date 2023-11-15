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

import 'controller/form_controller.dart';

class AwardsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final VoidCallback onBack;
  AwardsScreen(
      {super.key,
      required this.isEdit,
      required this.formKey,
      required this.onNext, required this.onBack});

  @override
  _AwardsScreenState createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  @override
  void initState() {
    super.initState();
    steps = formController.formData['awards'].length> 0 ? formController.formData['awards'].length :  1;
  }
  final FormController formController = Get.find<FormController>(tag: 'form-control');
  List<TextEditingController> awardNameControllers=[TextEditingController()];
  List<TextEditingController> issuedByControllers=[TextEditingController()];
  List<TextEditingController> datesController=[TextEditingController()];
  int steps = 1;
  List<Widget> buildsteps() {
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String? awardName = null, issuedBy = null, date = null;

      if (formController.formData['awards'].length >= i) {
        awardName = formController.formData['awards'][i-1]['awardName'];
        issuedBy = formController.formData['awards'][i-1]['issuedBy'];
        date = formController.formData['awards'][i-1]['date'];
        awardNameControllers.add(TextEditingController(text: awardName));
        issuedByControllers.add(TextEditingController(text: issuedBy));
        datesController.add(TextEditingController(text: date));
      }
      else {

        awardNameControllers.add(TextEditingController());
        issuedByControllers.add(TextEditingController());
        datesController.add(TextEditingController());
      }

      l.add(Column(
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
            keyName: 'awardName',
            controller: awardNameControllers[i],
          ),
          // Repeat for other fields
          DateButton(label: 'Date',dateController: datesController[i],),
          RequiredFieldWidget(
            label: 'Issued By',
            keyName: 'issuedBy',
            controller: issuedByControllers[i],
          ),
          i!=1? IconButton(
              onPressed: () {
               int index=i;
               print(steps.toString());
                setState(() {
                  steps--;
                  awardNameControllers.removeAt(index-1);
                  issuedByControllers.removeAt(index-1);
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
                    "Awards Screen",
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
                                    primary: Color(0xFF085399), // #085399
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                  ),
                                  icon: Icon(Icons
                                      .arrow_back), // Change the icon as needed
                                  label: Text('Next'),
                                ),
                              )
                            ]),
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

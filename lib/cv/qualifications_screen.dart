

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/cv/widgets/required_label.dart';
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
  final goToPage;
  QualificationsScreen({super.key, required this.isEdit,  required this.formKey, required this.onNext, required this.onBack, required this.email, required this.goToPage});
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

  int steps = -1;
  int lastSteps = -1;
  List<Widget> cachedSteps = [];
  void rebuildStepWidget(int idx) {
      if (idx > 0 && idx <= steps) {
        cachedSteps[idx-1] = buildStepItem(idx);
      }
  }
  List <Widget> addOrGetCachedSteps () {
    print({"steps" :steps, "last-steps":lastSteps});
    if (lastSteps == steps) {
      return cachedSteps;
    }
    if (steps > lastSteps) {

      degreeLevelControllers.add(TextEditingController());
      degreeFieldControllers.add(TextEditingController());
      otherContrllers.add(TextEditingController());
      startDatesController.add(TextEditingController());
      endDatesController.add(TextEditingController());
      universityControllers.add(TextEditingController());
      cachedSteps.add(
        buildStepItem(steps)
      );
      lastSteps = steps;
      return cachedSteps;
    }
    degreeLevelControllers.removeLast();
    degreeFieldControllers.removeLast();
    otherContrllers.removeLast();
    startDatesController.removeLast();
    endDatesController.removeLast();
    cachedSteps.removeLast();
    universityControllers.removeLast();
    lastSteps = steps;
    return cachedSteps;

  }
  Widget buildStepItem(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Qualification $i',
          style: TextStyle(
              color: Color(0xFF085399), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5,),
        RequiredFieldLabel(labelText: 'Degree Level', hideStar: true,),
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
          value: degreeLevelControllers[i].text.isNotEmpty ? degreeLevelControllers[i].text : null,
          hint: Text('Choose Degree level'),
          onChanged: (String? newValue) {
            if (newValue != null)
              setState(() {
                  degreeLevelControllers[i].text = newValue;
                  this.rebuildStepWidget(i);
              });

          },
          items: [
            'None',
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
          visible:( degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None'),
          child: Column(
            children: [
              RequiredFieldLabel(labelText: 'Degree Field', starColor: Colors.green,),
              DropdownButtonFormField<String>(
                value: degreeFieldControllers[i].text.isNotEmpty ? degreeFieldControllers[i].text : null,
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
                hint: Text('Choose Field'),
                onChanged: (String? newValue) {
                  setState(() {
                    degreeFieldControllers[i].text = newValue!;
                    this.rebuildStepWidget(i);
                  });
                },
                items: fields.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              RequiredFieldWidget(label:  degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text == 'High School' ? 'School Name' : 'University Name' , keyName: 'u-name', controller: universityControllers[i], starColor: Colors.green,)
            ],
          ),
        ) ,
        
        Visibility(child: RequiredFieldWidget(starColor: Colors.green,label: 'Custom Field', keyName: 'field', controller: otherContrllers[i]),visible: (degreeFieldControllers[i].text.isNotEmpty && degreeFieldControllers[i].text == 'other' && degreeLevelControllers[i].text != 'None' && degreeLevelControllers[i].text != 'Pre-high school'),),
        Visibility(child: DateButton(starColor: Colors.green,label: 'Start Date',dateController: startDatesController[i],mode: DatePickerButtonMode.year,lastDate: DateTime.now(),), visible: (degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None' ),),
        Visibility(child: DateButton(mode: DatePickerButtonMode.year, starColor: Colors.green,label: 'End Date',dateController: endDatesController[i],), visible: (degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None' ),) ,

      ],
    );
  }
  List<Widget> buildsteps() {
    degreeLevelControllers=[TextEditingController()];
    degreeFieldControllers=[TextEditingController()];
    otherContrllers=[TextEditingController()];
    startDatesController=[TextEditingController()];
    endDatesController=[TextEditingController()];
    universityControllers= [(TextEditingController())];
    List<Widget> l = [];

    for (int i = 1; i <= steps; i++) {
      String? level = null, field = null, other = "", sDate = "", endDate ="", uName = "";
      if (widget.formController.formData['qualifications'].length >= i) {
        level = widget.formController.formData['qualifications'][i-1]['DegreeLevel'];
        sDate = widget.formController.formData['qualifications'][i-1]['StartDate'];
        endDate = widget.formController.formData['qualifications'][i-1]['EndDate'];
        uName = widget.formController.formData['qualifications'][i-1]['IssuedBy'];
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

      l.add(buildStepItem(i));
    }
    return l;
  }
  @override
  void initState() {
    super.initState();
    steps = widget.formController.formData['qualifications'].length > 0 ? widget.formController.formData['qualifications'].length : 1;
    lastSteps = steps;
    fetchCategories().then((val) {
      fields = List<String>.from(val.map((e) {return e['CategoryName']; }));
      fields.add('other');
      setState(() {
        cachedSteps = buildsteps();
      });
    });
  }
  dynamic fetchCategories() async {
    final response = await http.get(Uri.parse(Connection.getQualifs));
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
                    "Qualifications",
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
                            Step(title: SizedBox(), content: SizedBox(), isActive: false, ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: false, ),

                          ],
                          type: StepperType.horizontal,

                        ),height: 75 ,),
                      ),

                      SizedBox(
                        height: screenHeight*0.59,
                        child:
                            ListView(children: [...addOrGetCachedSteps(),  Row(
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
                                ),
                              ],
                            )]
                            )
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
                                      widget.formController.formData['qualifications'] = [];
                                        for (int i = 1; i <= steps; i++) {
                                          print({
                                            'degree-level': degreeLevelControllers[i].text,
                                          });
                                          if (degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'None') {
                                            widget.formController.addQualification(
                                                {
                                                  'DegreeLevel': degreeLevelControllers[i].text,
                                                  'Field': degreeFieldControllers[i].text == 'other' ? otherContrllers[i].text : degreeFieldControllers[i].text,
                                                  'FieldFlag': degreeFieldControllers[i].text == 'other' ? 1 : 0,
                                                  'StartDate': startDatesController[i].text,
                                                  'EndDate': endDatesController[i].text,
                                                  'IssuedBy': universityControllers[i].text

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

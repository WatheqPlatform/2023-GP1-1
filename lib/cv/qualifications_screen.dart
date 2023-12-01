


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/cv/widgets/required_label.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<ValueNotifier<bool>> stillWorking = [
    ValueNotifier(false)
  ];
  int steps = -1;
  int lastSteps = -1;
  int MAX_STEPS = 0;
  int selectedIndex = -1;
  List<Widget> cachedSteps = [];
  void rebuildStepWidget(int idx) {
      if (idx > 0 && idx <= steps) {
        cachedSteps[idx-1] = buildStepItem(idx, idx);
      }
  }
  List <Widget> addOrGetCachedSteps () {
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
      stillWorking.add(ValueNotifier(true));
      cachedSteps.add(
        buildStepItem(steps, MAX_STEPS)
      );
      lastSteps = steps;
      return cachedSteps;
    }

    lastSteps = steps;
    removeWidget(selectedIndex);
    return cachedSteps;

  }
  void removeWidget(int i) {
    for (int j = 0; j < cachedSteps.length; j++) {
      if (cachedSteps[j].key == Key(i.toString())) {
        j++;
        degreeLevelControllers.removeAt(j);
        degreeFieldControllers.removeAt(j);
        otherContrllers.removeAt(j);
        startDatesController.removeAt(j);
        endDatesController.removeAt(j);
        cachedSteps.removeAt(j-1);
        universityControllers.removeAt(j);
        stillWorking.removeAt(j);
        return;
      }
    }
  }
  Widget buildStepItem(int i, int ?j) {
    j ??= i;
    return Column(
      key: Key(i.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (i != 1) SizedBox(height: 40,),
        Text(
          'Qualification $j',
          style: const TextStyle(
              color: Color(0xFF085399), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal:  8.0,
              vertical:  0.012,
            ),
          ),
          value: degreeLevelControllers[i].text.isNotEmpty ? degreeLevelControllers[i].text : null,
          hint: const Text('Choose Degree level'),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                  degreeLevelControllers[i].text = newValue;
                  rebuildStepWidget(i);
              });
            }

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
        Visibility(child: const SizedBox(height: 16,), visible: degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None',),
        if (fields.isNotEmpty)Visibility(
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal:  8.0,
                    vertical:  0.012,
                  ),
                ),
                hint: const Text('Choose Field'),
                onChanged: (String? newValue) {
                  setState(() {
                    degreeFieldControllers[i].text = newValue!;
                    rebuildStepWidget(i);
                  });
                },
                items: fields.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16,),
              RequiredFieldWidget(label:  degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text == 'High School' ? 'School Name' : 'University Name' , keyName: 'u-name', controller: universityControllers[i], starColor: Colors.green,)
            ],
          ),
        ) ,
        
        Visibility(visible: (degreeFieldControllers[i].text.isNotEmpty && degreeFieldControllers[i].text == 'other' && degreeLevelControllers[i].text != 'None' && degreeLevelControllers[i].text != 'Pre-high school'),child: RequiredFieldWidget(starColor: Colors.green,label: 'Custom Field', keyName: 'field', controller: otherContrllers[i]),),
        Visibility(visible: (degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None' ),child: DateButton(starColor: Colors.green,label: 'Start Date',dateController: startDatesController[i],mode: DatePickerButtonMode.year,lastDate: DateTime.now(),),),
        Visibility(
          visible: degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None' ,
          child:  Container(
            margin:  EdgeInsets.only(bottom: 16.0),
            child: Row(

            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

              children: [
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,

                value: stillWorking[i].value,
                onChanged: (value) {
                  setState(() {
                    stillWorking[i].value = value ?? false;
                    rebuildStepWidget(i);
                  });
                },
              ),
              Text('I am still studying here'),

            ],
        ),
          ),),
        Visibility(visible: (degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'Pre-high school' && degreeLevelControllers[i].text != 'None' ),
          child: DateButton( disabled: stillWorking[i].value, mode: DatePickerButtonMode.year, starColor: Colors.green,label: 'End Date',dateController: endDatesController[i],removeGutter: true,),) ,
        InkWell(
          onTap: () {
            setState(() {
              if (i == 1) {
                degreeLevelControllers[i].text="";
                degreeFieldControllers[i].text="";
                otherContrllers[i].text="";
                startDatesController[i].text="";
                endDatesController[i].text="";
                universityControllers[i].text="";
                rebuildStepWidget(i);
                return;
              }
              steps--;
              selectedIndex = i;
            });
          },

          child: Container(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          ),
        )
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
    stillWorking = [ValueNotifier(true)];
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String? level, field, other = "", sDate = "", endDate ="", uName = "";
      print(widget.formController.formData['qualifications']);
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
      print({
        'level': level,
        'field': field,
        'other': other,
        'sDate': sDate,
        'endDate': endDate,
        'uName': uName
      });
      stillWorking.add(ValueNotifier(endDate == null));
      degreeLevelControllers.add(TextEditingController(text: level));
      degreeFieldControllers.add(TextEditingController(text: field));
      otherContrllers.add(TextEditingController(text: other));
      startDatesController.add(TextEditingController(text: sDate));
      endDatesController.add(TextEditingController(text: endDate));
      universityControllers.add(TextEditingController(text: uName));

      l.add(buildStepItem(i, i));
    }
    return l;
  }
  @override
  void initState() {
    super.initState();
    steps = widget.formController.formData['qualifications'].length > 0 ? widget.formController.formData['qualifications'].length : 1;
    lastSteps = steps;
    MAX_STEPS = steps;
    fetchCategories().then((val) {
      fields = List<String>.from(val.map((e) {return e['CategoryName']; })).where((element) => element != 'None' && element != '').toList();
      fields.insert(0, 'Select');
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
                      return AlertDialog(        title: const Text('Confirmation'),
                        content: const Text(            'Are you sure you want to cancel?'),
                        actions: [          TextButton(
                          onPressed: () {              Navigator.of(context)
                              .pop();            },
                          child: const Text('No'),          ),
                          TextButton(            onPressed: () {
                            Get.offAll(ProfileScreen(email: widget.email));            },
                            child: const Text('Yes'),          ),
                        ],      );
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 1),
                  child: Text(
                    widget.formController.isEdit() ? "Edit CV" : "Create CV",
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
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 30,
                ),
                height: screenHeight * 0.899,
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
                      Container(
                        height: screenHeight * 0.73,
                        child: Column(
                          children: [
                            ConnectedCircles(pos: 2,),
                            const Center(
                              child: Text(
                                'Qualifications',
                                style: TextStyle(
                                    fontSize: 25,
                                    color:Color(0xFF085399),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(
                                height: screenHeight*0.57,
                                child:
                                ListView(padding: EdgeInsets.zero,children: [...addOrGetCachedSteps(),  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        steps++;
                                        MAX_STEPS++;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(0,10,0,0),
                                        child: const Icon(
                                          Icons.add_circle_outline,
                                          color: Color(0xFF085399),

                                        ),
                                      ),
                                    )
                                  ],
                                )]
                                )
                            ),

                          ],
                        ),
                      ),
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
                                    backgroundColor: Color(0xFF9E9E9E),
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Back'),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      widget.formController.formData['qualifications'] = [];
                                        for (int i = 1; i <= steps; i++) {
                                          if (degreeLevelControllers[i].text.isNotEmpty && degreeLevelControllers[i].text != 'None') {
                                            widget.formController.addQualification(
                                                {
                                                  'workingHere': stillWorking[i].value,
                                                  'DegreeLevel': degreeLevelControllers[i].text,
                                                  'Field':   degreeFieldControllers[i].text != 'Select' ?(   degreeFieldControllers[i].text == 'other' ? otherContrllers[i].text : degreeFieldControllers[i].text) : null,
                                                  'FieldFlag': degreeFieldControllers[i].text == 'other' ? 1 : 0,
                                                  'StartDate': startDatesController[i].text,
                                                  'EndDate':  !stillWorking[i].value ? endDatesController[i].text : null,
                                                  'IssuedBy': universityControllers[i].text

                                                });
                                          }
                                        }
                                        widget.onNext();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF085399),
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                    ),
                                    icon: const Icon(Icons
                                        .arrow_back),
                                    label: const Text('Next'),
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

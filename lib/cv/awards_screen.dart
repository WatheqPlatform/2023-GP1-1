

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/profile_screen.dart';
import 'package:intl/intl.dart' as intl;
import '../database_connection/connection.dart';
import '../error_messages.dart';
import 'package:http/http.dart' as http;
import 'controller/form_controller.dart';

class AwardsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final email;
  final VoidCallback onBack;
  final goToPage;

  const AwardsScreen(
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
    MAX_STEPS = steps;
    lastSteps = steps;
    cachedSteps = buildsteps();
  }
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    RegExp pattern = RegExp(r'^05\d{8}$');

    if (value.length != 10 || !value.startsWith(pattern)) {
      return 'Please enter a valid Saudi Number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  String? validateCV(Map<String, dynamic> data) {
    List<String> requiredFieldsCV = ['firstName', 'lastName', 'phoneNumber', 'contactEmail', 'seekerEmail', 'summary', 'city'];

    for (String field in requiredFieldsCV) {
      if (data[field] == null || data[field].toString().isEmpty) {
        return "Missing or empty field for CV: $field";
      }
    }

    if (validateEmail(data['contactEmail']) != null) return validateEmail(data['contactEmail']);
    if (validatePhone(data['phoneNumber']) != null) return validatePhone(data['phoneNumber']);

    if (data['qualifications'] != null && data['qualifications'] is List) {
      for (Map<String, dynamic> qualification in data['qualifications']) {
        List<String> requiredFieldsQualification = ['DegreeLevel', ];
        final messages = {
          'Field': (final v) => 'Degree Field',
          'IssuedBy': (final v) {
            if (v['DegreeLevel'] == 'High School') {
              return "School Name";
            }
            return "University Name";
          }
        };
        if (qualification['DegreeLevel'] != 'Pre-high school') {
          requiredFieldsQualification.addAll(['Field','IssuedBy', 'StartDate']);
        }
        if (qualification['workingHere'] == false) {
          requiredFieldsQualification.add('EndDate');
        }
        for (String field in requiredFieldsQualification) {
          if (qualification[field] == null || qualification[field].toString().isEmpty) {
            return "Missing or empty field in qualifications: ${messages[field]?.call(qualification) ?? field} ";
          }
        }

        if (qualification['StartDate'].isNotEmpty && (qualification['EndDate'] ?? '').isNotEmpty ) {
          DateTime startDate = intl.DateFormat('yyyy/MM/dd').parse(qualification['StartDate']);
          DateTime endDate = intl.DateFormat('yyyy/MM/dd').parse(qualification['EndDate']);

          if (startDate.isAfter(endDate)) {
            return "StartDate must be before EndDate in qualifications";
          }
        }
      }
    }
    if (data['experiences'] != null && data['experiences'] is List) {
      for (Map<String, dynamic> experience in data['experiences']) {
        List<String> requiredFieldsExperience = ['CategoryID', 'JobTitle', 'CompanyName', 'StartDate'];
        if (experience['workingHere'] == false) {
          requiredFieldsExperience.add('EndDate');
        }
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


    if (data['certificates'] != null && data['certificates'] is List) {
      for (Map<String, dynamic> award in data['certificates']) {
        List<String> requiredFieldsAward = ['certificateName', 'issuedBy', 'date'];

        for (String field in requiredFieldsAward) {
          if (award[field] == null || award[field].toString().isEmpty) {
            return "Missing or empty field in certificates: $field";
          }
        }
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



    return null;
  }

  addCV(dynamic body) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF024A8D),
            ),
          );
        },
      );
      String jsonString = json.encode(body);
      print(jsonString);
      var response = await http.post(
        Uri.parse(Connection.createCv),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );
      formController.reset();
      String status = body['ID'] != 0 ? "Edited" : "Created";
      ErrorMessage.show(
        context,
        "Success",
        18,
        " Your CV is successfully $status.",
        ContentType.success,
        const Color.fromARGB(255, 15, 152, 20),
      );
      Get.off(ProfileScreen(email: widget.email));

    } catch (e) {
    }
  }

  final FormController formController = Get.find<FormController>(tag: 'form-control');
  List<TextEditingController> awardNameControllers=[TextEditingController()];
  List<TextEditingController> issuedByControllers=[TextEditingController()];
  List<TextEditingController> datesController=[TextEditingController()];
  late int steps = -1;
  int MAX_STEPS = 0;
  late int lastSteps = -1;

  List<Widget> cachedSteps = [];

  Widget buildStepItem (int i, int? j) {
    j ??= i;
    return Column(
      key: Key(i.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (i != 1) SizedBox(height: 40,),
        Text(
          'Award $j',
          style: const TextStyle(
              color: Color(0xFF085399), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
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
          removeGutter: true,
        ),
        InkWell(
          onTap: () {
              setState(() {
                if (i == 1) {
                  datesController[i].text = "";
                  issuedByControllers[i].text ="";
                  awardNameControllers[i].text="";
                  cachedSteps[i-1] = buildStepItem(i, i);
                  return;
                }
                selectedIndex = i;
                steps--;
              });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          ),
        )

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
      String? awardName, issuedBy, date;

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

      l.add(buildStepItem(i, i));
    }
    return l;
  }
  int selectedIndex = 0;
  void removeWidget(int i) {
    for (int j = 0; j < cachedSteps.length; j++) {
      if (cachedSteps[j].key == Key(i.toString())){
        awardNameControllers.removeAt(j+1);
        issuedByControllers.removeAt(j+1);
        datesController.removeAt(j+1);
        cachedSteps.removeAt(j);
        return;
      }
    }
  }
  List<Widget> addOrGetCachedSteps() {
    if (lastSteps == steps) return cachedSteps;

    if (steps > lastSteps) {
      lastSteps = steps;
      awardNameControllers.add(TextEditingController());
      issuedByControllers.add(TextEditingController());
      datesController.add(TextEditingController());
      cachedSteps.add(
          buildStepItem(steps, MAX_STEPS)
      );

      return cachedSteps;
    }
    lastSteps = steps;
    removeWidget(selectedIndex);
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
                      formController.isEdit() ? "Edit CV" : "Create CV",
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
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 30,
                  ),
                  height: screenHeight * 0.96,
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
                              ConnectedCircles(pos: 6,),
                              Center(
                                child: const Text(
                                  'Awards',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color:Color(0xFF085399),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                  height: screenHeight*0.57,
                                  child: ListView(padding: EdgeInsets.zero,children: [...addOrGetCachedSteps(), Row(

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
                                      ]),
                                  ])),
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
                                      backgroundColor:Color(0xFF9E9E9E),
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
                                    child: ElevatedButton(
                                      onPressed: () {
                                        formController.formData.value['awards'] = [];
                                        for( int i=1;i<=steps;i++) {
                                          final data = {
                                            'awardName': awardNameControllers[i]
                                                .text,
                                            'issuedBy': issuedByControllers[i]
                                                .text,
                                            'date': datesController[i].text
                                          };
                                          if (awardNameControllers[i].text
                                              .isNotEmpty) {
                                            formController.addAward(data);
                                          }
                                        }
                                        final body = formController.formData.value;
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
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF085399),
                                        padding: const EdgeInsets.symmetric(horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        elevation: 5,
                                      ),

                                      child:  Text(formController.isEdit() ? "Edit CV" : "Create CV",),
                                    ),
                                  ),
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

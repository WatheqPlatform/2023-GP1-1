



import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/cv/widgets/required_label.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/profile_screen.dart';

import '../error_messages.dart';
import 'controller/form_controller.dart';


class ExperiencesScreen extends StatefulWidget {
  final String email;
  final VoidCallback onBack;
  final goToPage;
  ExperiencesScreen({super.key, required this.onBack, required this.email, required this.goToPage});
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

  List<String> fields = [];
  List <dynamic> fieldsWithId = [];
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
        List<String> requiredFieldsQualification = ['DegreeLevel', ];
        if (qualification['DegreeLevel'] != 'Pre-high school') {
            requiredFieldsQualification.addAll(['Field', 'StartDate', 'EndDate']);
        }
        for (String field in requiredFieldsQualification) {

          if (qualification[field] == null || qualification[field].toString().isEmpty) {
            return "Missing or empty field in qualifications: $field";
          }
        }
        if (qualification['StartDate'].isNotEmpty && qualification['EndDate'].isNotEmpty) {
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
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF024A8D),
            ),
          );
        },
      );
      String jsonString = json.encode(body);
      var response = await http.post(
        Uri.parse(Connection.createCv),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );
      widget.formController.reset();
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

  int steps = -1;
  int lastSteps = -1;
  int MAX_STEPS = 0;
  int selectedIndex = 0;
  Widget buildStepItem(int i, int? j) {
    j ??= i;
    return Column(
      key: Key(i.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (i != 1)SizedBox(height: 40,),
        Text(
          'Experience $j',
          style: const TextStyle(
              color: Color(0xFF085399), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
        if(fields.isNotEmpty) Column(
          children: [
            RequiredFieldLabel(labelText: 'Experience Industry',hideStar: true, ),
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
              value: experienceIndustryControllers[i].text.isNotEmpty ? experienceIndustryControllers[i].text : null,
              hint: const Text('Choose Industry'),
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
        const SizedBox(height: 16,),
        RequiredFieldWidget(
          label: 'Job Title',
          keyName: 'jobTitle',
          starColor: Colors.green,
          controller: jobTitleControllers[i],
        ),

        RequiredFieldWidget(
          label: 'Company Name',
          keyName: 'companyName',
          starColor: Colors.green,
          controller: companyNameControllers[i],
        ),
        DateButton(starColor: Colors.green,label: 'Start Date',dateController: startDatesController[i],mode: DatePickerButtonMode.month,),
        DateButton(removeGutter: true, starColor: Colors.green,label: 'End Date',dateController: endDatesController[i],mode: DatePickerButtonMode.month),
         (i != 1) ? IconButton(
          onPressed: () {
            setState(() {
              steps--;
              selectedIndex = i;
            });
          },
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
          ),
        ) : SizedBox(height: 0,width: 0,)
      ],
    );
  }
  List<Widget> cachedSteps = [];
  List<Widget> addOrGetCachedSteps() {
    if (steps == lastSteps) {
      return cachedSteps;
    }
    print({'object': steps, 'asdasd': lastSteps});
    if (steps > lastSteps) {

      jobTitleControllers.add(TextEditingController());
      companyNameControllers.add(TextEditingController());
      startDatesController.add(TextEditingController());
      endDatesController.add(TextEditingController());
      experienceIndustryControllers.add(TextEditingController());
      cachedSteps.add(
          buildStepItem(steps, MAX_STEPS)
      );
      steps = lastSteps;
      return cachedSteps;
    }
    steps = lastSteps;
    removeWidget();
    return cachedSteps;

  }
  void removeWidget() {
    for (int j = 0; j < cachedSteps.length; j++) {
      if (cachedSteps[j].key == Key(selectedIndex.toString())) {
        j++;
        companyNameControllers.removeAt(j);
        jobTitleControllers.removeAt(j);
        startDatesController.removeAt(j);
        endDatesController.removeAt(j);
        experienceIndustryControllers.removeAt(j);
        cachedSteps.removeAt(j-1);
      }
    }

  }
  List<Widget> buildsteps() {
    if (fieldsWithId.isEmpty || fields.isEmpty) {
      return [];
    }
     jobTitleControllers=[TextEditingController()];
     companyNameControllers=[TextEditingController()];
     startDatesController=[TextEditingController()];
    endDatesController=[TextEditingController()];
    experienceIndustryControllers=[TextEditingController()];
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String? category, jobTitle = '', company = '', startDate = '', endDate = '';

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
      l.add(buildStepItem(i, i));
    }
    return l;
  }
  @override
  void initState() {
    steps = widget.formController.formData['experiences'].length > 0 ? widget.formController.formData['experiences'].length : 1;
    lastSteps = steps;
    MAX_STEPS = steps;
    super.initState();
    fetchCategories().then((val) {
      fields =['None',... List<String>.from(val.map((e) {return e['CategoryName']; }))];

      fieldsWithId = List<dynamic>.from(val.map((e) {return e;} ));
      setState(() {
          cachedSteps = buildsteps();
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
            Expanded(child:SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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

                      Container(
                        height: screenHeight * .73,
                        child: Column(
                          children: [
                            ConnectedCircles(pos: 4,),
                            Center(
                              child: const Text(
                                'Experience',
                                style: TextStyle(
                                    fontSize: 25,
                                    color:Color(0xFF085399),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.59,
                              child: ListView(children: [
                                ...addOrGetCachedSteps(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    IconButton(
                                      onPressed: () {
                                        steps++;
                                        MAX_STEPS++;
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Color(0xFF085399),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(

                              onPressed: () {
                                widget.onBack();

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF085399),
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
                                  widget.formController.formData['experiences'] = [];
                                  for (int i = 1; i <= steps; i++) {
                                    if (experienceIndustryControllers[i].text.isNotEmpty && experienceIndustryControllers[i].text != 'None') {
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF085399),
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),

                                 child:  Text(widget.formController.isEdit() ? "Edit CV" : "Create CV",),
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

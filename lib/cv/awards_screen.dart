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
import 'package:awesome_dialog/awesome_dialog.dart';

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
      required this.onNext,
      required this.onBack,
      required this.email,
      required this.goToPage});

  @override
  _AwardsScreenState createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  @override
  void initState() {
    super.initState();
    steps = formController.formData['awards'].length > 0
        ? formController.formData['awards'].length
        : 1;
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
    List<String> requiredFieldsCV = [
      'firstName',
      'lastName',
      'phoneNumber',
      'contactEmail',
      'seekerEmail',
      'summary',
      'city'
    ];

    for (String field in requiredFieldsCV) {
      final fields = {
        'firstName': 'first name',
        'lastName': 'last name',
        'phoneNumber': 'phone number',
        'contactEmail': 'contact email',
        'city': 'city',
        'summary': 'professional summary'
      };

      data[field] = data[field].toString().trim();
      if (data[field] == null || data[field].toString().isEmpty) {
        return "Please fill in the ${fields[field] ?? field}";
      }
    }

    if (validateEmail(data['contactEmail']) != null)
      return validateEmail(data['contactEmail']);
    if (validatePhone(data['phoneNumber']) != null)
      return validatePhone(data['phoneNumber']);

    if (data['qualifications'] != null && data['qualifications'] is List) {
      for (Map<String, dynamic> qualification in data['qualifications']) {
        List<String> requiredFieldsQualification = [
          'DegreeLevel',
        ];
        final messages = {
          'Field': (final v) => 'Degree Field',
          'IssuedBy': (final v) {
            if (v['DegreeLevel'] == 'High School') {
              return "School Name";
            }
            return "University Name";
          },
          'StartDate': () => 'Start Date',
          'EndDate': () => 'End Date'
        };
        if (qualification['DegreeLevel'] != 'Pre-high school') {
          requiredFieldsQualification
              .addAll(['Field', 'IssuedBy', 'StartDate']);
          if (qualification['workingHere'] == false) {
            requiredFieldsQualification.add('EndDate');
          }
        }

        for (String field in requiredFieldsQualification) {
          if (qualification[field] == null ||
              qualification[field].toString().isEmpty) {
            return "The ${messages[field]?.call(qualification) ?? field} in qualifications is missing";
          }
        }

        if (qualification['StartDate'].isNotEmpty &&
            (qualification['EndDate'] ?? '').isNotEmpty) {
          DateTime startDate =
              intl.DateFormat('yyyy/MM/dd').parse(qualification['StartDate']);
          DateTime endDate =
              intl.DateFormat('yyyy/MM/dd').parse(qualification['EndDate']);

          if (startDate.isAfter(endDate)) {
            return "The startDate in qualifications must be before EndDate";
          }
        }
      }
    }
    if (data['experiences'] != null && data['experiences'] is List) {
      final messages = {
        'CategoryID': 'industry',
        'JobTitle': 'job title',
        'CompanyName': 'company name',
        'StartDate': 'start date',
        'EndDate': 'end date'
      };
      for (Map<String, dynamic> experience in data['experiences']) {
        List<String> requiredFieldsExperience = [
          'CategoryID',
          'JobTitle',
          'CompanyName',
          'StartDate'
        ];
        if (experience['workingHere'] == false) {
          requiredFieldsExperience.add('EndDate');
        }
        for (String field in requiredFieldsExperience) {
          if (experience[field] == null ||
              experience[field].toString().isEmpty) {
            return "The ${messages[field] ?? field} in experience is missing ";
          }
        }
        if (experience['StartDate'] != null && experience['EndDate'] != null) {
          DateTime startDate =
              intl.DateFormat('yyyy/MM/dd').parse(experience['StartDate']);
          DateTime endDate =
              intl.DateFormat('yyyy/MM/dd').parse(experience['EndDate']);

          if (startDate.isAfter(endDate)) {
            return "The startDate in experience must be before EndDate";
          }
        }
      }
    }
    String formatString(String input) {
      return input.replaceAllMapped(RegExp(r'([A-Z])'), (match) {
        return ' ' + match.group(1)!;
      }).trim();
    }

    if (data['projects'] != null && data['projects'] is List) {
      for (Map<String, dynamic> project in data['projects']) {
        List<String> requiredFieldsProject = [
          'ProjectName',
          'Description',
          'Date'
        ];

        for (String field in requiredFieldsProject) {
          if (project[field] == null || project[field].toString().isEmpty) {
            return "The ${formatString(field)} in project is missing";
          }
        }
      }
    }

    if (data['certificates'] != null && data['certificates'] is List) {
      for (Map<String, dynamic> award in data['certificates']) {
        List<String> requiredFieldsAward = [
          'certificateName',
          'issuedBy',
          'date'
        ];

        for (String field in requiredFieldsAward) {
          if (award[field] == null || award[field].toString().isEmpty) {
            return "The ${formatString(field[0].toUpperCase() + field.substring(1))} in award is missing";
          }
        }
      }
    }
    if (data['awards'] != null && data['awards'] is List) {
      for (Map<String, dynamic> award in data['awards']) {
        List<String> requiredFieldsAward = ['awardName', 'issuedBy', 'date'];

        for (String field in requiredFieldsAward) {
          if (award[field] == null || award[field].toString().isEmpty) {
            return "The $field in award is missing";
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

      await http.post(
        Uri.parse(Connection.createCv),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );
      formController.reset();
      String status = body['ID'] != 0 ? "edited" : "created";
      ErrorMessage.show(
        context,
        "Success",
        16,
        " You have successfully $status your CV",
        ContentType.success,
        const Color.fromARGB(255, 15, 152, 20),
      );
      Get.to(ProfileScreen(email: widget.email));
    } catch (e) {}
  }

  final FormController formController =
      Get.find<FormController>(tag: 'form-control');
  List<TextEditingController> awardNameControllers = [TextEditingController()];
  List<TextEditingController> issuedByControllers = [TextEditingController()];
  List<TextEditingController> datesController = [TextEditingController()];
  late int steps = -1;
  int MAX_STEPS = 0;
  late int lastSteps = -1;

  List<Widget> cachedSteps = [];

  Widget buildStepItem(int i, int? j) {
    j ??= i;
    return Column(
      key: Key(i.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (i != 1)
          SizedBox(
            height: 40,
          ),
        Text(
          'Award $j',
          style: const TextStyle(
              color: Color(0xFF085399),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const SizedBox(
          height: 7,
        ),
        RequiredFieldWidget(
          label: 'Award Name',
          controller: awardNameControllers[i],
          hideStar: true,
        ),
        DateButton(
          label: 'Date',
          dateController: datesController[i],
          starColor: Colors.green,
          lastDate: DateTime.now(),
        ),
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
                issuedByControllers[i].text = "";
                awardNameControllers[i].text = "";
                cachedSteps[i - 1] = buildStepItem(i, i);
                return;
              }
              selectedIndex = i;
              steps--;
            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
    awardNameControllers = [TextEditingController()];
    issuedByControllers = [TextEditingController()];
    datesController = [TextEditingController()];
    List<Widget> l = [];
    final x = formController.formData.value['awards'];

    for (int i = 1; i <= steps; i++) {
      String? awardName, issuedBy, date;

      if (x.length >= i) {
        awardName = x[i - 1]['awardName'];
        issuedBy = x[i - 1]['issuedBy'];
        date = x[i - 1]['date'];
        awardNameControllers.add(TextEditingController(text: awardName));
        issuedByControllers.add(TextEditingController(text: issuedBy));
        datesController.add(TextEditingController(text: date));
      } else {
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
      if (cachedSteps[j].key == Key(i.toString())) {
        awardNameControllers.removeAt(j + 1);
        issuedByControllers.removeAt(j + 1);
        datesController.removeAt(j + 1);
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
      cachedSteps.add(buildStepItem(steps, MAX_STEPS));

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
                AnimatedButton(
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: 'Confirmation',
                      desc:
                          'Are you sure you want to cancel? \n Your actions will not be saved.',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        Get.to(ProfileScreen(email: widget.email));
                      },
                      btnCancelColor: Colors.grey,
                      btnOkColor: Colors.red,
                      btnCancelText: 'NO',
                      btnOkText: 'YES',
                    )..show();
                  },
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 1),
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
                  height: screenHeight * 0.9,
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
                              ConnectedCircles(
                                pos: 6,
                              ),
                              const Center(
                                child: Text(
                                  'Awards',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color(0xFF085399),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "* Fill all fields to add award",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                    height: screenHeight * 0.57,
                                    child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          ...addOrGetCachedSteps(),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    steps++;
                                                    MAX_STEPS++;
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 10, 0, 0),
                                                    child: const Icon(
                                                      Icons.add_circle_outline,
                                                      color: Color(0xFF085399),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        ])),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        widget.onBack();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF9E9E9E),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        fixedSize: Size(screenWidth * 0.44,
                                            screenHeight * 0.05),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        elevation: 5,
                                      ),
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text(
                                        'Back',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 17),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final beforeList = [
                                            ...formController
                                                .formData.value['awards']
                                          ];
                                          formController
                                              .formData.value['awards'] = [];

                                          for (int i = 1; i <= steps; i++) {
                                            final data = {
                                              'id': i - 1 < beforeList.length
                                                  ? beforeList[i - 1]['id']
                                                  : null,
                                              'awardName':
                                                  awardNameControllers[i]
                                                      .text
                                                      .trim(),
                                              'issuedBy': issuedByControllers[i]
                                                  .text
                                                  .trim(),
                                              'date': datesController[i].text
                                            };
                                            if (awardNameControllers[i]
                                                .text
                                                .isNotEmpty) {
                                              formController.addAward(data);
                                            }
                                          }
                                          final body =
                                              formController.formData.value;
                                          body['seekerEmail'] = widget.email;
                                          String? validationError =
                                              validateCV(body);

                                          if (validationError == null) {
                                            addCV(body);
                                          } else {
                                            return ErrorMessage.show(
                                                context,
                                                "Error",
                                                16,
                                                validationError,
                                                ContentType.failure,
                                                const Color.fromARGB(
                                                    255, 209, 24, 24));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF085399),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40),
                                          fixedSize: Size(screenWidth * 0.44,
                                              screenHeight * 0.05),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 5,
                                        ),
                                        child: Text(
                                          formController.isEdit()
                                              ? "Edit "
                                              : "Create ",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
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

class AnimatedButton extends StatelessWidget {
  final VoidCallback pressEvent;
  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final Widget child;

  const AnimatedButton({
    Key? key,
    required this.pressEvent,
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressEvent,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

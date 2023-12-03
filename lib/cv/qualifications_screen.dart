import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/cv/widgets/required_label.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'controller/form_controller.dart';

class QualificationsScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final String email;
  QualificationsScreen({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.email,
  });
  final FormController formController = Get.find(tag: 'form-control');
  @override
  _QualificationsScreenState createState() => _QualificationsScreenState();
}

class _QualificationsScreenState extends State<QualificationsScreen> {
  List<TextEditingController> degreeLevelControllers = [
    TextEditingController()
  ];
  List<TextEditingController> degreeFieldControllers = [
    TextEditingController()
  ];
  List<TextEditingController> universityControllers = [TextEditingController()];
  List<TextEditingController> otherContrllers = [TextEditingController()];
  List<TextEditingController> startDatesController = [TextEditingController()];
  List<TextEditingController> endDatesController = [TextEditingController()];
  List<String> fields = [];
  List<ValueNotifier<bool>> stillWorking = [ValueNotifier(false)];
  int steps = -1;
  int lastSteps = -1;
  int MAX_STEPS = 0;
  int selectedIndex = -1;
  List<Widget> cachedSteps = [];
  void rebuildStepWidget(int idx) {
    if (idx > 0 && idx <= steps) {
      cachedSteps[idx - 1] = buildStepItem(idx, idx);
    }
  }

  List<Widget> addOrGetCachedSteps() {
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
      cachedSteps.add(buildStepItem(steps, MAX_STEPS));
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
        cachedSteps.removeAt(j - 1);
        universityControllers.removeAt(j);
        stillWorking.removeAt(j);
        return;
      }
    }
  }

  Widget buildStepItem(int i, int? j) {
    j ??= i;
    return Column(
      key: Key(i.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (i != 1)
          const SizedBox(
            height: 40,
          ),
        Text(
          'Qualification $j',
          style: const TextStyle(
              color: Color(0xFF085399),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const SizedBox(
          height: 7,
        ),
        RequiredFieldLabel(
          labelText: 'Degree Level',
          hideStar: true,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 0.012,
            ),
          ),
          value: degreeLevelControllers[i].text.isNotEmpty
              ? degreeLevelControllers[i].text
              : null,
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
        Visibility(
          child: const SizedBox(
            height: 16,
          ),
          visible: degreeLevelControllers[i].text.isNotEmpty &&
              degreeLevelControllers[i].text != 'Pre-high school' &&
              degreeLevelControllers[i].text != 'None',
        ),
        if (fields.isNotEmpty)
          Visibility(
            visible: (degreeLevelControllers[i].text.isNotEmpty &&
                degreeLevelControllers[i].text != 'Pre-high school' &&
                degreeLevelControllers[i].text != 'None'),
            child: Column(
              children: [
                RequiredFieldLabel(
                  labelText: 'Degree Field',
                  starColor: Colors.green,
                ),
                DropdownButtonFormField<String>(
                  value: degreeFieldControllers[i].text.isNotEmpty
                      ? degreeFieldControllers[i].text
                      : null,
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
                      horizontal: 8.0,
                      vertical: 0.012,
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
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                    visible: (degreeFieldControllers[i].text.isNotEmpty &&
                        degreeFieldControllers[i].text == 'other'),
                    child: RequiredFieldWidget(
                        starColor: Colors.green,
                        label: 'Custom Field',
                        keyName: 'field',
                        controller: otherContrllers[i])),
                RequiredFieldWidget(
                  label: degreeLevelControllers[i].text.isNotEmpty &&
                          degreeLevelControllers[i].text == 'High School'
                      ? 'School Name'
                      : 'University Name',
                  keyName: 'u-name',
                  controller: universityControllers[i],
                  starColor: Colors.green,
                )
              ],
            ),
          ),
        Visibility(
          visible: (degreeLevelControllers[i].text.isNotEmpty &&
              degreeLevelControllers[i].text != 'Pre-high school' &&
              degreeLevelControllers[i].text != 'None'),
          child: DateButton(
            starColor: Colors.green,
            label: 'Start Date',
            dateController: startDatesController[i],
            mode: DatePickerButtonMode.year,
            lastDate: DateTime.now(),
          ),
        ),
        Visibility(
          visible: degreeLevelControllers[i].text.isNotEmpty &&
              degreeLevelControllers[i].text != 'Pre-high school' &&
              degreeLevelControllers[i].text != 'None',
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  activeColor: const Color(0xFF14386E),
                  checkColor: Colors.white,
                  side: MaterialStateBorderSide.resolveWith((states) =>
                      const BorderSide(width: 2.0, color: Color(0xFF14386E))),
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
                const Text('I am still studying here'),
              ],
            ),
          ),
        ),
        Visibility(
          visible: (degreeLevelControllers[i].text.isNotEmpty &&
              degreeLevelControllers[i].text != 'Pre-high school' &&
              degreeLevelControllers[i].text != 'None'),
          child: DateButton(
            disabled: stillWorking[i].value,
            mode: DatePickerButtonMode.year,
            starColor: Colors.green,
            label: 'End Date',
            dateController: endDatesController[i],
            removeGutter: true,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (i == 1) {
                degreeLevelControllers[i].text = "";
                degreeFieldControllers[i].text = "";
                otherContrllers[i].text = "";
                startDatesController[i].text = "";
                endDatesController[i].text = "";
                universityControllers[i].text = "";
                rebuildStepWidget(i);
                return;
              }
              steps--;
              selectedIndex = i;
            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
    degreeLevelControllers = [TextEditingController()];
    degreeFieldControllers = [TextEditingController()];
    otherContrllers = [TextEditingController()];
    startDatesController = [TextEditingController()];
    endDatesController = [TextEditingController()];
    universityControllers = [(TextEditingController())];
    stillWorking = [ValueNotifier(true)];
    List<Widget> l = [];
    for (int i = 1; i <= steps; i++) {
      String? level, field, other = "", sDate = "", endDate = "", uName = "";

      if (widget.formController.formData['qualifications'].length >= i) {
        level = widget.formController.formData['qualifications'][i - 1]
            ['DegreeLevel'];
        sDate = widget.formController.formData['qualifications'][i - 1]
            ['StartDate'];
        endDate =
            widget.formController.formData['qualifications'][i - 1]['EndDate'];
        uName =
            widget.formController.formData['qualifications'][i - 1]['IssuedBy'];
        if (widget.formController.formData['qualifications'][i - 1]
                ['FieldFlag'] ==
            0) {
          field =
              widget.formController.formData['qualifications'][i - 1]['Field'];
        } else {
          other =
              widget.formController.formData['qualifications'][i - 1]['Field'];
          field = 'other';
        }
      }
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
    steps = widget.formController.formData['qualifications'].length > 0
        ? widget.formController.formData['qualifications'].length
        : 1;
    lastSteps = steps;
    MAX_STEPS = steps;
    fetchCategories().then((val) {
      fields = List<String>.from(val.map((e) {
        return e['CategoryName'];
      })).where((element) => element != 'None' && element != '').toList();
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
                        Navigator.of(context).pop();
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
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 1),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight * 0.73,
                          child: Column(
                            children: [
                              ConnectedCircles(
                                pos: 2,
                              ),
                              const Center(
                                child: Text(
                                  'Qualifications',
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
                                  "* Fill all fields to add qualification",
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
                                    height: screenHeight * 0.58,
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
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 0),
                                                  child: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Color(0xFF085399),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ])),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                widget.onBack();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9E9E9E),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                fixedSize: Size(
                                    screenWidth * 0.43, screenHeight * 0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
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
                          const SizedBox(
                            width: 17,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final beforeList = [
                                    ...widget.formController.formData
                                        .value['qualifications']
                                  ];
                                  widget.formController
                                      .formData['qualifications'] = [];
                                  for (int i = 1; i <= steps; i++) {
                                    List<String> requiredFields = [
                                      universityControllers[i].text,
                                      degreeLevelControllers[i].text,
                                      degreeFieldControllers[i].text,
                                      startDatesController[i].text
                                    ];
                                    if (requiredFields
                                            .any((e) => e.isNotEmpty) &&
                                        degreeLevelControllers[i].text !=
                                            'None') {
                                      widget.formController.addQualification({
                                        'id': i - 1 < beforeList.length
                                            ? beforeList[i - 1]['id']
                                            : null,
                                        'workingHere': stillWorking[i].value,
                                        'DegreeLevel':
                                            degreeLevelControllers[i].text,
                                        'Field': degreeFieldControllers[i]
                                                    .text !=
                                                'Select'
                                            ? (degreeFieldControllers[i].text ==
                                                    'other'
                                                ? otherContrllers[i].text
                                                : degreeFieldControllers[i]
                                                    .text)
                                            : null,
                                        'FieldFlag':
                                            degreeFieldControllers[i].text ==
                                                    'other'
                                                ? 1
                                                : 0,
                                        'StartDate':
                                            startDatesController[i].text,
                                        'EndDate': !stillWorking[i].value
                                            ? endDatesController[i].text
                                            : null,
                                        'IssuedBy':
                                            universityControllers[i].text
                                      });
                                    }
                                  }
                                  widget.onNext();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF085399),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  fixedSize: Size(
                                      screenWidth * 0.43, screenHeight * 0.05),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
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
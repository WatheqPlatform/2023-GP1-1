import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../profile_screen.dart';
import 'controller/form_controller.dart';

class ProjectsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final email;
  final goToPage;
  ProjectsScreen(
      {super.key,
      required this.isEdit,
      required this.formKey,
      required this.onNext,
      required this.onBack,
      required this.email,
      required this.goToPage});
  final FormController formController = Get.find(tag: 'form-control');
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<TextEditingController> projectNameControllers = [
    TextEditingController()
  ];
  List<TextEditingController> descriptionControllers = [
    TextEditingController()
  ];
  List<TextEditingController> datesControllers = [TextEditingController()];
  int steps = -1;
  int lastSteps = -1;
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
          'Project $j',
          style: const TextStyle(
              color: Color(0xFF085399),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const SizedBox(
          height: 7,
        ),
        RequiredFieldWidget(
          label: 'Project Name',
          keyName: 'projectName',
          hideStar: true,
          controller: projectNameControllers[i],
        ),
        DateButton(
          label: 'Completion Date',
          dateController: datesControllers[i],
          starColor: Colors.green,
        ),
        RequiredFieldWidget(
          label: 'Description',
          keyName: 'description',
          controller: descriptionControllers[i],
          starColor: Colors.green,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          removeGutter: true,
          maxLength: 500,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (i == 1) {
                projectNameControllers[i].text = "";
                descriptionControllers[i].text = "";
                datesControllers[i].text = "";
                cachedSteps[i - 1] = buildStepItem(i, i);
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
    List<Widget> l = [];
    projectNameControllers = [TextEditingController()];
    descriptionControllers = [TextEditingController()];
    datesControllers = [TextEditingController()];
    for (int i = 1; i <= steps; i++) {
      String projectName = "", description = "", date = "";
      if (widget.formController.formData['projects'].length >= i) {
        projectName =
            widget.formController.formData['projects'][i - 1]['ProjectName'];
        description =
            widget.formController.formData['projects'][i - 1]['Description'];
        date = widget.formController.formData['projects'][i - 1]['Date'];
      }
      projectNameControllers.add(TextEditingController(text: projectName));
      descriptionControllers.add(TextEditingController(text: description));
      datesControllers.add(TextEditingController(text: date));
      l.add(buildStepItem(i, i));
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
      cachedSteps.add(buildStepItem(steps, MAX_STEPS));
      return cachedSteps;
    }
    lastSteps = steps;
    removeWidget();
    return cachedSteps;
  }

  void removeWidget() {
    for (int j = 0; j < cachedSteps.length; j++) {
      if (cachedSteps[j].key == Key(selectedIndex.toString())) {
        j++;
        datesControllers.removeAt(j);
        projectNameControllers.removeAt(j);
        descriptionControllers.removeAt(j);
        cachedSteps.removeAt(j - 1);
        return;
      }
    }
  }

  int selectedIndex = 0;
  int MAX_STEPS = 0;
  @override
  void initState() {
    steps = widget.formController.formData['projects'].length > 0
        ? widget.formController.formData['projects'].length
        : 1;
    lastSteps = steps;
    MAX_STEPS = steps;
    cachedSteps = buildsteps();
    super.initState();
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
                    key: widget.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight * 0.73,
                          child: Column(
                            children: [
                              ConnectedCircles(
                                pos: 4,
                              ),
                              const Center(
                                child: Text(
                                  'Projects',
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
                                  "* Fill all fields to add project",
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
                                  height: screenHeight * 0.54,
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
                                            ])
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    widget.onBack();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF9E9E9E),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    fixedSize: Size(screenWidth * 0.44,
                                        screenHeight * 0.05),
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
                                            .value['projects']
                                      ];
                                      widget.formController
                                          .formData['projects'] = [];

                                      for (int i = 1; i <= steps; i++) {
                                        List<String> reqs = [
                                          projectNameControllers[i].text,
                                          descriptionControllers[i].text,
                                          datesControllers[i].text
                                        ];
                                        if (reqs.any(
                                            (element) => element.isNotEmpty)) {
                                          widget.formController.addProject({
                                            'ProjectName':
                                                projectNameControllers[i]
                                                    .text
                                                    .trim(),
                                            'Description':
                                                descriptionControllers[i]
                                                    .text
                                                    .trim(),
                                            'Date': datesControllers[i].text,
                                            'id': i - 1 < beforeList.length
                                                ? beforeList[i - 1]['id']
                                                : null
                                          });
                                        }
                                      }
                                      widget.onNext();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF085399),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      fixedSize: Size(screenWidth * 0.44,
                                          screenHeight * 0.05),
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

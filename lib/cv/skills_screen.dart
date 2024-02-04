import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'controller/form_controller.dart';
import 'package:watheq/profile_screen.dart';

class SkillsScreen extends StatefulWidget {
  final VoidCallback onNext;
  final String email;
  final VoidCallback onBack;

  const SkillsScreen({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.email,
  });

  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  @override
  void initState() {
    super.initState();
    steps = formController.formData['skills'].length > 0
        ? formController.formData['skills'].length
        : 1;
    MAX_STEPS = steps;
    lastSteps = steps;
    cachedSteps = buildsteps();
  }

  final FormController formController =
      Get.find<FormController>(tag: 'form-control');
  List<TextEditingController> descriptionControllers = [
    TextEditingController()
  ];
  late int steps = 1;
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
            height: 30,
          ),
        RequiredFieldWidget(
          label: 'Skill $j',
          controller: descriptionControllers[i],
          hideStar: true,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (i == 1) {
                descriptionControllers[i].text = "";
                return;
              }
              selectedIndex = i;
              steps--;
            });
          },
          child: Container(
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
    if (steps == -1) {
      return [];
    }
    descriptionControllers = [TextEditingController()];
    List<Widget> l = [];
    final x = formController.formData.value['skills'];

    for (int i = 1; i <= steps; i++) {
      if (x.length >= i) {
        String description = x[i - 1]['Description'];
        descriptionControllers.add(TextEditingController(text: description));
      } else {
        descriptionControllers.add(TextEditingController());
      }

      l.add(buildStepItem(i, i));
    }
    return l;
  }

  int selectedIndex = 0;
  void removeWidget(int i) {
    for (int j = 0; j < cachedSteps.length; j++) {
      if (cachedSteps[j].key == Key(i.toString())) {
        descriptionControllers.removeAt(j + 1);
        cachedSteps.removeAt(j);
        return;
      }
    }
  }

  List<Widget> addOrGetCachedSteps() {
    if (lastSteps == steps) return cachedSteps;

    if (steps > lastSteps) {
      lastSteps = steps;
      descriptionControllers.add(TextEditingController());
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
                      btnOkColor: Color(0xFFD93D46),
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
                                pos: 1,
                              ),
                              const Text(
                                'Skills',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFF085399),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 0),
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
                                    ...formController.formData.value['skills']
                                  ];
                                  formController.formData.value['skills'] = [];
                                  for (int i = 1; i <= steps; i++) {
                                    final data = {
                                      'Description':
                                          descriptionControllers[i].text.trim(),
                                      'id': i - 1 < beforeList.length
                                          ? beforeList[i - 1]['id']
                                          : null
                                    };
                                    if (descriptionControllers[i]
                                        .text
                                        .isNotEmpty) {
                                      formController.addSkill(data);
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

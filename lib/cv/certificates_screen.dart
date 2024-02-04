import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'controller/form_controller.dart';
import 'package:watheq/profile_screen.dart';

class CertificatesScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final email;
  final VoidCallback onBack;
  final goToPage;

  const CertificatesScreen(
      {super.key,
      required this.isEdit,
      required this.formKey,
      required this.onNext,
      required this.onBack,
      required this.email,
      required this.goToPage});

  @override
  _CertificatesScreenState createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  @override
  void initState() {
    super.initState();
    steps = formController.formData['certificates'].length > 0
        ? formController.formData['certificates'].length
        : 1;
    MAX_STEPS = steps;
    lastSteps = steps;
    cachedSteps = buildsteps();
  }

  final FormController formController =
      Get.find<FormController>(tag: 'form-control');
  List<TextEditingController> certificateNameControllers = [
    TextEditingController()
  ];
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
          'Certificate $j',
          style: const TextStyle(
              color: Color(0xFF085399),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const SizedBox(
          height: 0,
        ),
        RequiredFieldWidget(
          label: 'Certificate Name',
          fontWeight: FontWeight.normal,
          controller: certificateNameControllers[i],
          hideStar: true,
        ),
        DateButton(
          label: 'Date',
          dateController: datesController[i],
          starColor: Colors.grey,
          lastDate: DateTime.now(),
        ),
        RequiredFieldWidget(
          label: 'Issued By',
          fontWeight: FontWeight.normal,
          controller: issuedByControllers[i],
          starColor: Colors.grey,
          removeGutter: true,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (i == 1) {
                datesController[i].text = "";
                issuedByControllers[i].text = "";
                certificateNameControllers[i].text = "";
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
    certificateNameControllers = [TextEditingController()];
    issuedByControllers = [TextEditingController()];
    datesController = [TextEditingController()];
    List<Widget> l = [];
    final x = formController.formData.value['certificates'];

    for (int i = 1; i <= steps; i++) {
      String? awardName, issuedBy, date;

      if (x.length >= i) {
        awardName = x[i - 1]['certificateName'];
        issuedBy = x[i - 1]['issuedBy'];
        date = x[i - 1]['date'];
        certificateNameControllers.add(TextEditingController(text: awardName));
        issuedByControllers.add(TextEditingController(text: issuedBy));
        datesController.add(TextEditingController(text: date));
      } else {
        certificateNameControllers.add(TextEditingController());
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
        certificateNameControllers.removeAt(j + 1);
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
      certificateNameControllers.add(TextEditingController());
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
                    key: widget.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight * 0.73,
                          child: Column(
                            children: [
                              ConnectedCircles(
                                pos: 5,
                              ),
                              const Center(
                                child: Text(
                                  'Certificates',
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
                                  "* Indicates required field to add certificate",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
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
                                    backgroundColor: const Color(0xFF9E9E9E),
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
                              SizedBox(width: 17),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      widget.formKey.currentState!.save();
                                      final beforeList = [
                                        ...formController
                                            .formData.value['certificates']
                                      ];
                                      formController
                                          .formData.value['certificates'] = [];

                                      for (int i = 1; i <= steps; i++) {
                                        final data = {
                                          'id': i - 1 < beforeList.length
                                              ? beforeList[i - 1]['id']
                                              : null,
                                          'certificateName':
                                              certificateNameControllers[i]
                                                  .text
                                                  .trim(),
                                          'issuedBy': issuedByControllers[i]
                                              .text
                                              .trim(),
                                          'date': datesController[i].text
                                        };
                                        List<String> reqs = [
                                          certificateNameControllers[i].text,
                                          issuedByControllers[i].text,
                                          datesController[i].text
                                        ];
                                        if (reqs.any(
                                            (element) => element.isNotEmpty)) {
                                          formController.addCertificate(data);
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

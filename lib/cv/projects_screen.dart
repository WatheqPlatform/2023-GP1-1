


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/date_button.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';

import '../profile_screen.dart';
import 'controller/form_controller.dart';

class ProjectsScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final email;
  final goToPage;
  ProjectsScreen({super.key, required this.isEdit,  required this.formKey, required this.onNext, required this.onBack, required this.email, required this.goToPage});
  final FormController formController = Get.find( tag: 'form-control' );
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<TextEditingController> projectNameControllers=[TextEditingController()];
  List<TextEditingController> descriptionControllers=[TextEditingController()];
  List<TextEditingController> datesControllers=[TextEditingController()];
  int steps = -1;
  int lastSteps = -1;
  List<Widget> cachedSteps = [];
  Widget buildStepItem(int i, int ?j) {
    j ??= i;
    return Column(
      key: Key(i.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (i != 1) SizedBox(height: 40,),
        Text(
          'Project $j',
          style: const TextStyle(
              color: Color(0xFF085399), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
        RequiredFieldWidget(
          label: 'Project Name',
          keyName: 'projectName',
          hideStar: true,
          controller: projectNameControllers[i],
        ),
        DateButton(label: 'Completion Date',dateController: datesControllers[i],starColor: Colors.green,), RequiredFieldWidget(
          label: 'Description',
          keyName: 'description',
          controller: descriptionControllers[i],
          starColor: Colors.green,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          removeGutter: true,
        ),

        i != 1 ? InkWell(
          onTap: () {
            setState(() {
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
        ) :const SizedBox(width: 0,height: 0,),
      ],
    );
  }
  List<Widget> buildsteps() {
    List<Widget> l = [];
     projectNameControllers=[TextEditingController()];
     descriptionControllers=[TextEditingController()];
     datesControllers=[TextEditingController()];
    for (int i = 1; i <= steps; i++) {
      String projectName = "", description = "", date = "";
      if (widget.formController.formData['projects'].length >= i) {
        projectName = widget.formController.formData['projects'][i-1]['ProjectName'];
        description = widget.formController.formData['projects'][i-1]['Description'];
        date = widget.formController.formData['projects'][i-1]['Date'];
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
    steps = widget.formController.formData['projects'].length > 0 ? widget.formController.formData['projects'].length : 1;
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
                height: screenHeight * 0.89,
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
                        height: screenHeight * 0.77,
                        child: Column(
                          children: [
                            ConnectedCircles(pos: 3,),
                            const Center(
                              child: Text(
                                'Projects',
                                style: TextStyle(
                                    fontSize: 25,
                                    color:Color(0xFF085399),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.57,
                              child: ListView(children: [
                                ...addOrGetCachedSteps(),
                                Row(
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
                                    ])
                              ]),
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
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      widget.formController.formData['projects'] = [];
                                      for (int i = 1; i <= steps; i++) {
                                        if (projectNameControllers[i].text.isNotEmpty) {
                                          widget.formController.addProject({
                                          'ProjectName': projectNameControllers[i].text,
                                          'Description': descriptionControllers[i].text,
                                          'Date': datesControllers[i].text,
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

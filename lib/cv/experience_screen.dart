



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
import 'package:awesome_dialog/awesome_dialog.dart';
import '../error_messages.dart';
import 'controller/form_controller.dart';


class ExperiencesScreen extends StatefulWidget {
  final String email;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final goToPage;
  ExperiencesScreen({super.key, required this.onBack, required this.email, required this.goToPage, required this.onNext});
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
  List<ValueNotifier<bool>> stillWorking = [
    ValueNotifier(false)
  ];
  List<String> fields = [];
  List <dynamic> fieldsWithId = [];

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
        Container(
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
                    cachedSteps[i-1] = buildStepItem(i, i);
                  });
                },
              ),
              Text('I am still working in this position'),

            ],
          ),
        ),
        DateButton(disabled: stillWorking[i].value,removeGutter: true, starColor: Colors.green,label: 'End Date',dateController: endDatesController[i],mode: DatePickerButtonMode.month, lastDate: DateTime.now(),),
        InkWell(
          onTap: () {
            setState(() {
              if (i == 1) {
                jobTitleControllers[i].text="";
                companyNameControllers[i].text="";
                startDatesController[i].text="";
                endDatesController[i].text="";
                experienceIndustryControllers[i].text="None";
                cachedSteps[i-1] = buildStepItem(i, i);
                return;
              }
              steps--;
              selectedIndex = i;
            });
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
  List<Widget> cachedSteps = [];
  List<Widget> addOrGetCachedSteps() {
    if (steps == lastSteps) {
      return cachedSteps;
    }
    if (steps > lastSteps) {

      jobTitleControllers.add(TextEditingController());
      companyNameControllers.add(TextEditingController());
      startDatesController.add(TextEditingController());
      endDatesController.add(TextEditingController());
      experienceIndustryControllers.add(TextEditingController());
      stillWorking.add(ValueNotifier(false));
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
        stillWorking.removeAt(j);
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
    stillWorking = [ValueNotifier(false)];
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
      stillWorking.add(ValueNotifier(endDate == null));
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
                AnimatedButton(
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: 'Confirmation',
                      desc: 'Are you sure you want to cancel?',
                      btnCancelOnPress: () {
                        
                      },
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
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),          
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
                        height: screenHeight * .73,
                        child: Column(
                          children: [
                            ConnectedCircles(pos: 3,),
                            Center(
                              child: const Text(
                                'Experiences',
                                style: TextStyle(
                                    fontSize: 25,
                                    color:Color(0xFF085399),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.57,
                              child: ListView(padding: EdgeInsets.zero,children: [
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
                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: const Icon(
                                          Icons.add_circle_outline,
                                          color: Color(0xFF085399),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Spacer( ),
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
                                  final beforeList = [...widget.formController.formData.value['experiences']];
                                  widget.formController.formData['experiences'] = [];

                                  for (int i = 1; i <= steps; i++) {
                                    if (experienceIndustryControllers[i].text.isNotEmpty && experienceIndustryControllers[i].text != 'None') {
                                      widget.formController.addExperience({
                                        'id': i - 1 < beforeList.length ? beforeList[i-1]['id'] : null,
                                        'workingHere': stillWorking[i].value,
                                        'CategoryID': fieldsWithId.where((element) => element['CategoryName'] == experienceIndustryControllers[i].text).first['CategoryID'],
                                        'JobTitle': jobTitleControllers[i].text,
                                        'CompanyName': companyNameControllers[i].text,
                                        'StartDate': startDatesController[i].text,
                                        'EndDate': stillWorking[i].value ? null : endDatesController[i].text,
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
                ),
              ),
            ),)
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
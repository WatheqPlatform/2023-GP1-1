

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/cv/widgets/required_label.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/offers_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/Applications_Screen.dart';

import '../profile_screen.dart';
import 'controller/form_controller.dart';

class BasicInformationScreen extends StatefulWidget {
  final isEdit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final email;
  final goToPage;
  BasicInformationScreen({super.key, required this.isEdit, required this.formKey, required this.onNext, required this.email, required this.goToPage});
  final FormController formController = Get.put(FormController(), tag: 'form-control');
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  List<Map<String, dynamic>> cities = [];
  late List<DropdownMenuItem<Map<String, dynamic>>> cityDropdownItems =[];



  @override
  void initState() {
    
    super.initState();
    fetchCities().then((value) {
      setState(() {
        cityDropdownItems = List<DropdownMenuItem<Map<String, dynamic>>>.from(value.map((city) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: city,
            child: Text(city['CityName'].toString()),
          );
        }));
        cities = List<Map<String, dynamic>>.from(value.map((city) {
          return city;
        }));
      });



    });
  }
  dynamic fetchCities() async {
    final response = await http.get(Uri.parse(Connection.getCities));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load cities');
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int currentStep = 0;
    String firstName = "", lastName = "", phoneNumber = "", contactEmail = "", summary = "";
    firstName = widget.formController.formData['firstName'] ?? '';
    lastName = widget.formController.formData['lastName'] ?? '';
    phoneNumber = widget.formController.formData['phoneNumber']?.toString() ?? '';
    contactEmail = widget.formController.formData['contactEmail'] ?? '';
    summary = widget.formController.formData['summary'] ?? '';
    final TextEditingController firstNameController = TextEditingController(text: firstName);
    final TextEditingController lastNameController = TextEditingController(text: lastName);
    final TextEditingController phoneNumberController = TextEditingController(text: phoneNumber);
    final TextEditingController contactEmailController = TextEditingController(text: contactEmail);
    final TextEditingController summaryController = TextEditingController(text: summary);

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
                const SizedBox(width: 55),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 1),
                  child: Text(
                    "Basic Information",
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
                physics: NeverScrollableScrollPhysics(),
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
                    key: widget.formKey,
                    child: Column(
                    children: [
                      Theme(
                          data: ThemeData(  shadowColor: const Color.fromARGB(0, 255, 255, 255),backgroundColor: Colors.transparent,
                  canvasColor: Colors.transparent,
                  colorScheme: ColorScheme.light(
                    primary: Color(0xFF085399),
                    
                  )),
                        child: SizedBox(child:Stepper(
                          
                          steps: const [
                            Step(title: SizedBox(width: 0,), content: SizedBox(), isActive: true,   ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true,  ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true, ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true, ),
                            Step(title: SizedBox(), content: SizedBox(), isActive: true, ),
                      
                          ],
                          currentStep: 2,
                          onStepTapped: (int index){
                            widget.goToPage(index);
                          },
                          type: StepperType.horizontal,
                      
                        ),height: 75 ,),
                      ),
                      RequiredFieldWidget(label: 'First Name',keyName: 'firstName',controller: firstNameController,),
                      RequiredFieldWidget(label: 'Last Name',keyName: 'lastName',controller: lastNameController,),
                      RequiredFieldWidget(label: 'Phone Number',keyName: 'phoneNumber',controller: phoneNumberController,),
                      RequiredFieldWidget(label: 'Contact Email',keyName: 'contactEmail',controller: contactEmailController,),

                      RequiredFieldWidget(label: 'Summary',keyName: 'summary',controller: summaryController,),
                      // Repeat for other fields
                      RequiredFieldLabel(labelText: 'City',),

                      if (cities.length > 0) DropdownButtonFormField<Map<String, dynamic>>(
                        items: cityDropdownItems,
                        value: (cities.firstWhereOrNull((element) => element['CityId'] == widget.formController.formData['city'].toString()) ),
                        key: Key('city'),
                        onChanged: (Map<String, dynamic>? selectedCity) {
                          if (selectedCity != null) {
                            widget.formController.updateFormData({'city': selectedCity['CityId']});
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF085399)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF085399)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                        ),
                      ),
                      SizedBox(height:screenHeight * 0.07 ,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Are you sure you want to cancel?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.off(ProfileScreen(email: widget.email));
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            icon: Icon(Icons.cancel),
                            label: Text(''),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                widget.formKey.currentState!.save();
                                widget.formController.updateFormData({ 'firstName': firstNameController.text });
                                widget.formController.updateFormData({'lastName': lastNameController.text});
                                widget.formController.updateFormData({'summary': summaryController.text});
                                widget.formController.updateFormData({'phoneNumber': phoneNumberController.text});
                                widget.formController.updateFormData({'contactEmail': contactEmailController.text});
                                print(widget.formController.formData);
                                widget.onNext();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF085399),
                                padding:EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              icon: Icon(Icons.arrow_back),
                              label: Text('Next'),

                            ),
                          )
                      ]
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

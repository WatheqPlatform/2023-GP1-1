


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/cv/widgets/circles_bar.dart';
import 'package:watheq/cv/widgets/required_field_widget.dart';
import 'package:watheq/cv/widgets/required_label.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/offer_details_screen.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  @override
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
                    children: [

                      SizedBox(
                        height: screenHeight*0.73,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: ConnectedCircles(pos: 0,),
                              ),
                              Center(
                                child: const Text(
                                  'Personal Information',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color:Color(0xFF085399),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),


                              RequiredFieldWidget(label: 'First Name',keyName: 'firstName',controller: firstNameController,),
                              RequiredFieldWidget(label: 'Last Name',keyName: 'lastName',controller: lastNameController,),
                              RequiredFieldWidget(keyboardType: TextInputType.phone, label: 'Phone Number',keyName: 'phoneNumber',controller: phoneNumberController,),
                              RequiredFieldWidget(label: 'Contact Email',keyName: 'contactEmail',controller: contactEmailController,),


                              RequiredFieldLabel(labelText: 'City',),

                              if (cities.isNotEmpty) DropdownButtonFormField<Map<String, dynamic>>(
                                items: cityDropdownItems,
                                value: (cities.firstWhereOrNull((element) => element['CityId'] == widget.formController.formData['city'].toString()) ),
                                key: const Key('city'),
                                onChanged: (Map<String, dynamic>? selectedCity) {
                                  if (selectedCity != null) {
                                    widget.formController.updateFormData({'city': selectedCity['CityId']});
                                  }
                                },
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF085399)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF085399)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                ),
                              ),
                              SizedBox(height: 16,),
                              RequiredFieldWidget(maxLength: 500, keyboardType: TextInputType.multiline,maxLines: 5, label: 'Professional Summary',keyName: 'summary',controller: summaryController,),
                            ],
                          ),
                        ),
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(

                              onPressed: () {
                                if (widget.formKey.currentState!.validate()) {
                                }
                                else {
                                }
                                widget.formKey.currentState!.save();
                                widget.formController.updateFormData({ 'firstName': firstNameController.text });
                                widget.formController.updateFormData({'lastName': lastNameController.text});
                                widget.formController.updateFormData({'summary': summaryController.text});
                                widget.formController.updateFormData({'phoneNumber': phoneNumberController.text});
                                widget.formController.updateFormData({'contactEmail': contactEmailController.text});
                                widget.onNext();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF085399),
                                padding:const EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),

                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Next'),

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
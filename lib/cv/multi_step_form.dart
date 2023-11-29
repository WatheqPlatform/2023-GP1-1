// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:watheq/cv/projects_screen.dart';
import 'package:watheq/cv/qualifications_screen.dart';
import 'awards_screen.dart';
import 'basic_information.dart';
import 'experience_screen.dart';
import 'skills_screen.dart';

class MultiStepForm extends StatefulWidget {
  final isEdit = false;
  final email;

  const MultiStepForm({super.key, required this.email});


  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _formKeys.length) {
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage = pageIndex;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          BasicInformationScreen(goToPage: goToPage, formKey: _formKeys[0],onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease), isEdit: null,email : widget.email),
          SkillsScreen(goToPage: goToPage,onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease), isEdit: null, onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease),email:widget.email),
          QualificationsScreen(goToPage: goToPage,formKey: _formKeys[2],onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease), isEdit: null,  onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease),email:widget.email),
          ProjectsScreen(goToPage: goToPage,formKey: _formKeys[3],onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease), isEdit: null,  onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease),email:widget.email),
          AwardsScreen(goToPage: goToPage,formKey: _formKeys[1],onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease), isEdit: null, onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease),email:widget.email),
          ExperiencesScreen(goToPage: goToPage,email: widget.email, onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 500), curve:  Curves.ease)
          ),
        ],
      ),
    );
  }
}

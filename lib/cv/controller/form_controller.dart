import 'package:get/get.dart';

class FormController extends GetxController {
  final formData = <String, dynamic>{
    'firstName': '',
    'lastName': '',
    'phoneNumber': 0,
    'contactEmail': '',
    'summary': '',
    'city': 0,
    'ID': 0,
    'seekerEmail': '',
    'awards': [],
    'qualifications': [],
    'projects': [],
    'experiences': [],
  }.obs;
  void reset() {
    formData.value = {'firstName': '',
    'lastName': '',
    'ID': 0,
    'phoneNumber': 0,
    'contactEmail': '',
    'summary': '',
    'city': 0,
    'seekerEmail': '',
    'awards': [],
    'qualifications': [],
    'projects': [],
    'experiences': []};
  }
  void addAward(Map<String, dynamic> award) {
    formData['awards'].add(award);
    update();
  }

  void addQualification(Map<String, dynamic> qualification) {
    formData['qualifications'].add(qualification);
    update();
  }

  void addProject(Map<String, dynamic> project) {
    formData['projects'].add(project);
    update();
  }

  void addExperience(Map<String, dynamic> experience) {
    formData['experiences'].add(experience);
    update();
  }
  void updateFormData(Map<String, dynamic> newData) {
    formData.addAll(newData);
    update();
  }
}

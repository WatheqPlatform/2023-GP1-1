import 'package:get/get.dart';

class FormController extends GetxController {
  final formData = <String, dynamic>{
    'firstName': '',
    'lastName': '',
    'phoneNumber': null,
    'contactEmail': '',
    'summary': '',
    'city': '',
    'ID': 0,
    'seekerEmail': '',
    'awards': [],
    'qualifications': [],
    'projects': [],
    'experiences': [],
    'skills': [],
    'certificates': [],
  }.obs;
  void reset() {
    formData.value = {'firstName': '',
    'lastName': '',
    'ID': 0,
    'phoneNumber': null,
    'contactEmail': '',
    'summary': '',
    'city': '',
    'seekerEmail': '',
    'awards': [],
    'qualifications': [],
    'projects': [],
      'skills': [],
      'certificates': [],
    'experiences': []};
  }
  void addAward(Map<String, dynamic> award) {
    formData['awards'].add(award);
    update();
  }
  void addSkill(Map<String, dynamic> a) {
    formData['skills'].add(a);
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
  void addCertificate(Map<String, dynamic> x) {
    formData['certificates'].add(x);
    update();
  }
  bool isEdit () {
    return formData.value['ID'] != 0;
  }
}

class JobOffer {
  final String offerID;
  final String jobTitle;
  final String jobDescription;
  final String category;
  final String field;
  final String employmentType;
  final String locationAddress;
  final String city;
  final String minSalary;
  final String maxSalary;
  final String status;
  final String date;
  final String startingDate;
  final String workingDays;
  final String workingHours;
  final String additionalNotes;
  final String companyName;

  JobOffer({
    required this.offerID,
    required this.jobTitle,
    required this.jobDescription,
    required this.category,
    required this.field,
    required this.employmentType,
    required this.locationAddress,
    required this.city,
    required this.minSalary,
    required this.maxSalary,
    required this.status,
    required this.date,
    required this.startingDate,
    required this.workingDays,
    required this.workingHours,
    required this.additionalNotes,
    required this.companyName,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      offerID: json['OfferID'],
      jobTitle: json['JobTitle'],
      jobDescription: json['JobDescription'],
      category: json['Category'],
      field: json['Field'],
      employmentType: json['EmploymentType'],
      locationAddress: json['LocationAddress'],
      city: json['City'],
      minSalary: json['MinSalary'],
      maxSalary: json['MaxSalary'],
      status: json['Status'],
      date: json['Date'],
      startingDate: json['StartingDate'],
      workingDays: json['WorkingDays'],
      workingHours: json['WorkingHours'],
      additionalNotes: json['AdditionalNotes'],
      companyName: json['CompanyName'] ?? '',
    );
  }
}

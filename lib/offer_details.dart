import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'JobOffer.model.dart';

class JobOfferDetailScreen extends StatelessWidget {
  final JobOffer jobOffer;

  JobOfferDetailScreen({required this.jobOffer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Offer Details'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    jobOffer.jobTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    jobOffer.jobDescription,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Category'),
                  subtitle: Text(jobOffer.category),
                ),
                Divider(),
                ListTile(
                  title: Text('Employment Type'),
                  subtitle: Text(jobOffer.employmentType),
                ),
                Divider(),
                ListTile(
                  title: Text('Location'),
                  subtitle: Text('${jobOffer.locationAddress}, ${jobOffer.city}'),
                ),
                Divider(),
                ListTile(
                  title: Text('Salary'),
                  subtitle: Text('\$${jobOffer.minSalary} - \$${jobOffer.maxSalary}'),
                ),
                Divider(),
                ListTile(
                  title: Text('Status'),
                  subtitle: Text(jobOffer.status),
                ),
                Divider(),
                ListTile(
                  title: Text('Date'),
                  subtitle: Text(jobOffer.date),
                ),
                Divider(),
                ListTile(
                  title: Text('Starting Date'),
                  subtitle: Text(jobOffer.startingDate),
                ),
                Divider(),
                ListTile(
                  title: Text('Working Days'),
                  subtitle: Text(jobOffer.workingDays),
                ),
                Divider(),
                ListTile(
                  title: Text('Working Hours'),
                  subtitle: Text(jobOffer.workingHours),
                ),
                Divider(),
                ListTile(
                  title: Text('Additional Notes'),
                  subtitle: Text(jobOffer.additionalNotes),
                ),
                Divider(),
                ListTile(
                  title: Text('Company Name'),
                  subtitle: Text(jobOffer.companyName),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

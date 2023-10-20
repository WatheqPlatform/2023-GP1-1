// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class JobOfferDetailScreen extends StatelessWidget {
  int index;
  List offer = [];

  JobOfferDetailScreen({super.key, required this.offer, required this.index});

  //checking optional fields value

  Widget startingDateCheck() {
    if (offer[index]["StartingDate"] != null) {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Starting Date'),
            subtitle: Text("${offer[index]["StartingDate"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget workingDaysCheck() {
    if (offer[index]["WorkingDays"] != null) {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Working Days'),
            subtitle: Text("${offer[index]["WorkingDays"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget workingHoursCheck() {
    if (offer[index]["WorkingHours"] != null) {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Working Hours'),
            subtitle: Text("${offer[index]["WorkingHours"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget notesCheck() {
    if (offer[index]["AdditionalNotes"] != null) {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Additional Notes'),
            subtitle: Text("${offer[index]["AdditionalNotes"]}"),
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Offer Details'),
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${offer[index]["JobTitle"]}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${offer[index]["JobDescription"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Category'),
                  subtitle: Text("${offer[index]["Category"]}"),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Employment Type'),
                  subtitle: Text("${offer[index]["EmploymentType"]}"),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Location'),
                  subtitle: Text("${offer[index]["JobAddress"]}"
                      "${offer[index]["City"]}"),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Salary'),
                  subtitle: Text(
                      "${offer[index]["MinSalary"]} - ${offer[index]["MaxSalary"]}"),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Status'),
                  subtitle: Text("${offer[index]["Status"]}"),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text("${offer[index]["Date"]}"),
                ),
                startingDateCheck(),
                workingDaysCheck(),
                workingHoursCheck(),
                notesCheck(),
                const Divider(),
                ListTile(
                  title: const Text('Company Name'),
                  subtitle: Text("${offer[index]["CompanyName"]}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

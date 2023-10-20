import 'package:flutter/material.dart';

class JobOfferDetailScreen extends StatelessWidget {
  int index;
  List Offer = [];

  JobOfferDetailScreen({required this.Offer, required this.index});

  //checking optional fields value

  Widget StartingDateCheck() {
    if (Offer[index]["StartingDate"] != null ||
        Offer[index]["StartingDate"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Starting Date'),
              subtitle: Text("${Offer[index]["StartingDate"]}"),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget WorkingDaysCheck() {
    if (Offer[index]["WorkingDays"] != null ||
        Offer[index]["WorkingDays"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Working Days'),
              subtitle: Text("${Offer[index]["WorkingDays"]}"),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget WorkingHoursCheck() {
    if (Offer[index]["WorkingHours"] != null ||
        Offer[index]["WorkingHours"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Working Hours'),
              subtitle: Text("${Offer[index]["WorkingHours"]}"),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget NotesCheck() {
    if (Offer[index]["AdditionalNotes"] != null ||
        Offer[index]["AdditionalNotes"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Additional Notes'),
              subtitle: Text("${Offer[index]["AdditionalNotes"]}"),
            ),
          ],
        ),
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
                    "${Offer[index]["JobTitle"]}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${Offer[index]["JobDescription"]}",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Category'),
                  subtitle: Text("${Offer[index]["Category"]}"),
                ),
                Divider(),
                ListTile(
                  title: Text('Employment Type'),
                  subtitle: Text("${Offer[index]["EmploymentType"]}"),
                ),
                Divider(),
                ListTile(
                  title: Text('Location'),
                  subtitle: Text("${Offer[index]["JobAddress"]}" +
                      "${Offer[index]["City"]}"),
                ),
                Divider(),
                ListTile(
                  title: Text('Salary'),
                  subtitle: Text("${Offer[index]["MinSalary"]}" +
                      " - " +
                      "${Offer[index]["MaxSalary"]}"),
                ),
                Divider(),
                ListTile(
                  title: Text('Status'),
                  subtitle: Text("${Offer[index]["Status"]}"),
                ),
                Divider(),
                ListTile(
                  title: Text('Date'),
                  subtitle: Text("${Offer[index]["Date"]}"),
                ),
                StartingDateCheck(),
                WorkingDaysCheck(),
                WorkingHoursCheck(),
                NotesCheck(),
                Divider(),
                ListTile(
                  title: Text('Company Name'),
                  subtitle: Text("${Offer[index]["CompanyName"]}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

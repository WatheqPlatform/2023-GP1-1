import 'package:flutter/material.dart';
import 'package:watheq_app/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobOfferDetailScreen extends StatefulWidget {
  var OfferID;

  JobOfferDetailScreen({
    required this.OfferID,
  });

  @override
  State<JobOfferDetailScreen> createState() => _StateJobOfferDetailScreen();
}

class _StateJobOfferDetailScreen extends State<JobOfferDetailScreen> {
  List OfferDetails = [];

  bool empty = true;

  Future<void> getdata() async {
    var res = await http.post(
      Uri.parse(Connection.jobDetailData),
      body: {"ID": widget.OfferID},
    );

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      setState(() {
        OfferDetails.addAll(red);
        empty = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  //checking optional fields value

  Widget StartingDateCheck() {
    if (OfferDetails[0]["StartingDate"] != null &&
        OfferDetails[0]["StartingDate"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Starting Date'),
              subtitle: Text("${OfferDetails[0]["StartingDate"]}"),
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
    if (OfferDetails[0]["WorkingDays"] != null &&
        OfferDetails[0]["WorkingDays"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Working Days'),
              subtitle: Text("${OfferDetails[0]["WorkingDays"]}"),
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
    if (OfferDetails[0]["WorkingHours"] != null &&
        OfferDetails[0]["WorkingHours"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Working Hours'),
              subtitle: Text("${OfferDetails[0]["WorkingHours"]}"),
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
    if (OfferDetails[0]["AdditionalNotes"] != null &&
        OfferDetails[0]["AdditionalNotes"] != "") {
      return Container(
        child: Column(
          children: [
            Divider(),
            ListTile(
              title: Text('Additional Notes'),
              subtitle: Text("${OfferDetails[0]["AdditionalNotes"]}"),
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
      body: empty
          ? null
          : ListView(
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
                          "${OfferDetails[0]["JobTitle"]}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "${OfferDetails[0]["JobDescription"]}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Category'),
                        subtitle: Text("${OfferDetails[0]["Category"]}"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Employment Type'),
                        subtitle: Text("${OfferDetails[0]["EmploymentType"]}"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Location'),
                        subtitle: Text("${OfferDetails[0]["JobAddress"]}" +
                            "${OfferDetails[0]["City"]}"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Salary'),
                        subtitle: Text("${OfferDetails[0]["MinSalary"]}" +
                            " - " +
                            "${OfferDetails[0]["MaxSalary"]}"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Status'),
                        subtitle: Text("${OfferDetails[0]["Status"]}"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Date'),
                        subtitle: Text("${OfferDetails[0]["Date"]}"),
                      ),
                      StartingDateCheck(),
                      WorkingDaysCheck(),
                      WorkingHoursCheck(),
                      NotesCheck(),
                      Divider(),
                      ListTile(
                        title: Text('Company Name'),
                        subtitle: Text("${OfferDetails[0]["CompanyName"]}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

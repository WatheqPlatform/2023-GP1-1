// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobOfferDetailScreen extends StatefulWidget {
  var offerID;

  JobOfferDetailScreen({
    super.key,
    required this.offerID,
  });

  @override
  State<JobOfferDetailScreen> createState() => _StateJobOfferDetailScreen();
}

class _StateJobOfferDetailScreen extends State<JobOfferDetailScreen> {
  List offerDetails = [];

  bool empty = true;

  Future<void> getdata() async {
    var res = await http.post(
      Uri.parse(Connection.jobDetailData),
      body: {"ID": widget.offerID},
    );

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      setState(() {
        offerDetails.addAll(red);
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

  Widget startingDateCheck() {
    if (offerDetails[0]["StartingDate"] != null &&
        offerDetails[0]["StartingDate"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Starting Date'),
            subtitle: Text("${offerDetails[0]["StartingDate"]}"),
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
    if (offerDetails[0]["WorkingDays"] != null &&
        offerDetails[0]["WorkingDays"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Working Days'),
            subtitle: Text("${offerDetails[0]["WorkingDays"]}"),
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
    if (offerDetails[0]["WorkingHours"] != null &&
        offerDetails[0]["WorkingHours"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Working Hours'),
            subtitle: Text("${offerDetails[0]["WorkingHours"]}"),
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
    if (offerDetails[0]["AdditionalNotes"] != null &&
        offerDetails[0]["AdditionalNotes"] != "") {
      return Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Additional Notes'),
            subtitle: Text("${offerDetails[0]["AdditionalNotes"]}"),
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
                          "${offerDetails[0]["JobTitle"]}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "${offerDetails[0]["JobDescription"]}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Category'),
                        subtitle: Text("${offerDetails[0]["Category"]}"),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Employment Type'),
                        subtitle: Text("${offerDetails[0]["EmploymentType"]}"),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Location'),
                        subtitle: Text("${offerDetails[0]["JobAddress"]}"
                            "${offerDetails[0]["City"]}"),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Salary'),
                        subtitle: Text(
                            "${offerDetails[0]["MinSalary"]} - ${offerDetails[0]["MaxSalary"]}"),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Status'),
                        subtitle: Text("${offerDetails[0]["Status"]}"),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Date'),
                        subtitle: Text("${offerDetails[0]["Date"]}"),
                      ),
                      startingDateCheck(),
                      workingDaysCheck(),
                      workingHoursCheck(),
                      notesCheck(),
                      const Divider(),
                      ListTile(
                        title: const Text('Company Name'),
                        subtitle: Text("${offerDetails[0]["CompanyName"]}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:watheq_app/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:watheq_app/Authentication/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen({required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';

  Future<void> fetchUserData() async {
    try {
      var response = await http
          .get(Uri.parse('${Connection.jobSeekerData}?email=${widget.email}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            firstName = data[0]['FirstName'];
            lastName = data[0]['LastName'];
            email = data[0]['JobSeekerEmail'];
          });
        }
      } else {
        // Handle error response
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or API errors
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Navigate back to the previous screen
              },
              child: Text('Back'),
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Full Name: $firstName $lastName',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Spacer(), // Add Spacer to push the logout button to the bottom
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                Get.offAll(LoginScreen());
              },
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

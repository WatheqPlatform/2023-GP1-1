// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:watheq_app/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:watheq_app/Authentication/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';

// logout container
  Widget logoutButton() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logout Confirmation'),
                content: const Text('Are you sure you want to log out?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                      // Perform the logout action here
                      Get.offAll(
                          const LoginScreen()); // Navigate to login screen and remove all previous screens from the stack
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Logout'),
      ),
    );
  }

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
      }
    } catch (e) {
      // Handle network or API errors
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
        title: const Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Navigate back to the previous screen
              },
              child: const Text('Back'),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Full Name: $firstName $lastName',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: $email',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const Spacer(), // Add Spacer to push the logout button to the bottom
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout Confirmation'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                            // Perform the logout action here
                            Get.offAll(
                                const LoginScreen()); // Navigate to login screen and remove all previous screens from the stack
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

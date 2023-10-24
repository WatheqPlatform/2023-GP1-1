// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ignore: non_constant_identifier_names
  String Name = '';

  String email = '';

  Future<void> fetchUserData() async {
    try {
      var response = await http
          .get(Uri.parse('${Connection.jobSeekerData}?email=${widget.email}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            Name = data[0]['Name'];
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
                'Full Name: $Name',
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
                Get.offAll(const LoginScreen());
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

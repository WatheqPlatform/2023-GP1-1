import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:watheq_app/Authentication/login_screen.dart';
import 'package:watheq_app/profile.dart';
import 'package:watheq_app/database_connection/connection.dart';

class OffersScreen extends StatefulWidget {
  //const OffersScreen({Key? key});

  final String email;

  OffersScreen({required this.email});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  List allOffers = [];
  List foundOffers = [];

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
                title: Text('Logout Confirmation'),
                content: Text('Are you sure you want to log out?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                      // Perform the logout action here
                      Get.offAll(
                          LoginScreen()); // Navigate to login screen and remove all previous screens from the stack
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Text('Logout'),
      ),
    );
  }

// profile button
  Widget profileButton() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProfileScreen(email: widget.email),
            ),
          );
        },
        child: Text('Profile'),
      ),
    );
  }

  Future<void> getdata() async {
    var res = await http.get(Uri.parse(Connection.jobOffersData));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      // Update the allOffers
      setState(() {
        allOffers.addAll(red);
        foundOffers.addAll(red);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    print(allOffers);
  }

  void searchOffer(String searchedWord) {
    List results = [];
    if (searchedWord.isEmpty) {
      results = allOffers;
    } else {
      results = allOffers
          .where((element) =>
              (element["JobTitle"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())) ||
              (element["CompanyName"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())) ||
              (element["Field"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())))
          .toList();
    }

    setState(() {
      foundOffers = results;
      print(foundOffers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          logoutButton(),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) => searchOffer(value),
              decoration: const InputDecoration(
                hintText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          foundOffers.isEmpty
              ? const Center(
                  // Display a message when the allOffers is empty
                  child: Text('No job offers found.'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: foundOffers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(241, 246, 245, 245),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, -3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text("${foundOffers[index]["JobTitle"]}"),
                            subtitle:
                                Text("${foundOffers[index]["CompanyName"]}"),
                            trailing: Text("${foundOffers[index]["Date"]}"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          profileButton(), // Pass the BuildContext to the profileButton
        ],
      ),
    );
  }
}

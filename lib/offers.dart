import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watheq_app/jobOffer.model.dart';
import 'dart:convert';
import 'package:watheq_app/profile.dart';
import 'package:watheq_app/database_connection/connection.dart';
import 'package:get/get.dart';

import 'offer_details.dart';

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
        print(red);
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
              (element["Category"]
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
          SizedBox(
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
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: () {
                            JobOffer x = JobOffer.fromJson(foundOffers[index]);
                            Get.to(()=>JobOfferDetailScreen(jobOffer: x,));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(241, 246, 245, 245),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
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
                              title: Text("${foundOffers[index]["JobTitle"]}" +
                                  "\n ${foundOffers[index]["Category"]}"),
                              subtitle:
                                  Text("${foundOffers[index]["CompanyName"]}"),
                              trailing: Text("${foundOffers[index]["Date"]}"),
                            ),
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

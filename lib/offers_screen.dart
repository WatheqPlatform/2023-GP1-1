import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/profile_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:get/get.dart';
import 'offer_details_screen.dart';

class OffersScreen extends StatefulWidget {
  final String email;

  const OffersScreen({super.key, required this.email});

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
        child: const Text('Profile'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/PagesBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          "Hello Shouq!",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          size: 39,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: screenWidth * 0.809,
                        height: screenWidth * 0.09,
                        child: TextField(
                          onChanged: (value) => searchOffer(value),
                          decoration: InputDecoration(
                            hintText: "Search by job title, field, or company",
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFFD3D3D3),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: const TextStyle(
                              color: Color(0xFFD3D3D3),
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                              top: screenHeight * 0.01,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.80,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.03,
                horizontal: screenWidth * 0.1,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3B000000),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
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
                                    onTap: () {
                                      Get.to(() => JobOfferDetailScreen(
                                            offerID: foundOffers[index]
                                                ["OfferID"],
                                          ));
                                    },
                                    title: Text(
                                        "${foundOffers[index]["JobTitle"]}"
                                        "\n ${foundOffers[index]["Category"]}"),
                                    subtitle: Text(
                                        "${foundOffers[index]["CompanyName"]}"),
                                    trailing:
                                        Text("${foundOffers[index]["Date"]}"),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  profileButton(), // Pass the BuildContext to the profileButton
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/offer_details_screen.dart';
import 'package:watheq/offers_screen.dart';
import 'package:http/http.dart' as http;
import 'database_connection/connection.dart';
import 'package:timeago/timeago.dart' as timeago;

// Renamed Notification to avoid conflict with Flutter's Notification class.
class NotificationScreen extends StatefulWidget {
  final String email;

  const NotificationScreen({super.key, required this.email});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List list = [];
  bool hasUnseenNotifications = false;

  Future ReadData() async {
    var res = await http.post(
      Uri.parse(Connection.getNotification),
      body: {"email": widget.email},
    );

    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);

      setState(() {
        list = red.reversed.toList();
        hasUnseenNotifications = list.any((notif) => notif['isSeen'] == 0);
      });
    }
  }

  Future markNotificationsAsSeen() async {
    var res = await http.post(
      Uri.parse(Connection.markNotifications),
      body: {"email": widget.email},
    );
  }

  @override
  void initState() {
    super.initState();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
            const SizedBox(
              height: 42,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 2,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OffersScreen(
                                email: "FO@gmail.com",
                              )),
                    );
                    markNotificationsAsSeen();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 7,
                    left: 1,
                  ),
                  child: Text(
                    "Notification Center",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 27,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.95,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
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
                child: Stack(
                  children: [
                    list.isEmpty
                        ? const Center(
                            child: Text('No Notifications yet.'),
                          )
                        : Expanded(
                            child: SizedBox(
                              height: screenHeight * 0.80,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(80.0),
                                ),
                                child: ListView.builder(
                                  itemCount: list.length,
                                  padding: const EdgeInsets.only(top: 25),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                          left: 5,
                                          right: 5,
                                          bottom: 5,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(JobOfferDetailScreen(
                                              offerID:
                                                  "${list[index]["OfferID"]}",
                                              email: widget.email,
                                            ));
                                          },
                                          child: Container(
                                            width: screenWidth,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Color.fromARGB(
                                                      169, 158, 158, 158),
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 20,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 2),
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: (list[index]
                                                                  ["isSeen"] ==
                                                              0)
                                                          ? Colors.red
                                                          : const Color(
                                                                  0xFF14386E)
                                                              .withOpacity(
                                                              0.8,
                                                            ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.83,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Discover new opportunities",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF14386E),
                                                            fontSize: 21.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Great news! the ${list[index]["JobTitle"].toLowerCase()} role at ${list[index]["CompanyName"].toLowerCase()} matches your cv by ${list[index]["Score"] * 100}%, apply now.",
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    155,
                                                                    155,
                                                                    155),
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 8),
                                                          child: Text(
                                                            timeago.format(
                                                                DateTime.parse(
                                                                    list[index][
                                                                        "Date"])),
                                                            //"
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      155,
                                                                      155,
                                                                      155),
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ),
                  ],
                  //
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

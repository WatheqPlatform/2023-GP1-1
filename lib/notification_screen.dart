import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/offer_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:watheq/offers_screen.dart';
import 'database_connection/connection.dart';
import 'package:timeago/timeago.dart' as timeago;

// Renamed Notification to avoid conflict with Flutter's Notification class.
class NotificationScreen extends StatefulWidget {
  final String email;

  const NotificationScreen({super.key, required this.email});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class NotificationContent {
  final String title;
  final String message;

  NotificationContent({required this.title, required this.message});
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

  String _displayTime(String dateString) {
    final date = DateTime.parse(dateString);
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else {
      String timeAgo = timeago.format(date);
      // Remove 'ago' if it exists
      return timeAgo.replaceAll(' ago', '');
    }
  }

  NotificationContent? _parseNotificationContent(
      Map<String, dynamic> notification) {
    final details = notification['Details'] as String;

    if (!details.contains(':')) {
      return null; // do not display it
    }

    final parts = details.split(':');

    final type = parts[0];
    // Assuming the job title is passed directly in the notification data.
    final jobTitle = notification["JobTitle"];
    final companyName = notification["CompanyName"];

    String message;
    String title;

    switch (type) {
      case 'match':
        final score = double.tryParse(parts[2]) ?? 0;
        title = "Discover New Opportunity";
        message =
            "The $jobTitle role at $companyName matches your CV by ${(score * 100).toStringAsFixed(2)}%, apply now!";
        break;
      case 'application':
        final applicationStatus = parts.length > 2 ? parts[2] : '';
        final statusText = applicationStatus == '1' ? "accepted" : "rejected";
        title = "Application Update";
        message =
            "Your application for the $jobTitle role at $companyName has been $statusText.";
        break;
      default:
        title = "Notification";
        message = "You have a new notification.";
        break;
    }

    return NotificationContent(title: title, message: message);
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
                    markNotificationsAsSeen();

                    Get.to(OffersScreen(email: widget.email));
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
                              height: screenHeight,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(80.0),
                                ),
                                child: ListView.builder(
                                  itemCount: list.length,
                                  padding: const EdgeInsets.only(top: 25),
                                  itemBuilder: (context, index) {
                                    final notification = list[index];
                                    final content =
                                        _parseNotificationContent(notification);
                                    if (content == null) {
                                      return Container();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15.0),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(JobOfferDetailScreen(
                                            offerID:
                                                "${notification["OfferID"]}",
                                            email: widget.email,
                                          ));

                                          setState(() {
                                            notification["isSeen"] = 1;
                                          });
                                        },
                                        child: Container(
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: index == list.length - 1
                                                ? Border.all(
                                                    color: Colors.transparent)
                                                : Border(
                                                    bottom: BorderSide(
                                                      color: Color.fromARGB(
                                                          169, 158, 158, 158),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10, top: 7),
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: (notification[
                                                              "isSeen"] ==
                                                          0)
                                                      ? Colors.red
                                                      : const Color(0xFF14386E)
                                                          .withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            content.title,
                                                            style: TextStyle(
                                                              color: (notification[
                                                                          "isSeen"] ==
                                                                      0)
                                                                  ? Colors.red
                                                                  : const Color(
                                                                      0xFF14386E),
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Text(
                                                          _displayTime(
                                                              notification[
                                                                  "Date"]),
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    155,
                                                                    155,
                                                                    155),
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0,
                                                              bottom: 14),
                                                      child: Text(
                                                          content.message,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    155,
                                                                    155,
                                                                    155),
                                                            fontSize: 15.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
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

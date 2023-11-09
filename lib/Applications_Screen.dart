import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watheq/Authentication/login_screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watheq/offers_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/profile_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  final String email;

  const ApplicationsScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreen();
}

class _ApplicationsScreen extends State<ApplicationsScreen> {

  List list = [];

  Future ReadData() async{
     var res = await http.post(
      Uri.parse(Connection.jobSeekerApplication),
     body: {"email": widget.email},
     );

    if(res.statusCode == 200){
      var red = jsonDecode(res.body);

      setState(() {
        list.addAll(red);
      });
    }
  }
 
 void initState(){
  super.initState();
  ReadData();
 }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int selectedIndex = 1;
    return Scaffold(
      body: list.isEmpty
      ? Center(
          child: Text('No Applications Found.'),
        )
      : ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx,i){ //loop
        return ListTile(
          title: Text(list[i]['CompanyName']),
          subtitle: Text(list[i]['JobTitle']),
          trailing: Text(list[i]['ApplicationStatus']),
        );
        },
        ),
         bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        width: 370,
        margin: EdgeInsets.only(
          top: screenHeight * 0.76,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(29, 0, 0, 0),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: GNav(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            color: const Color.fromARGB(255, 66, 66, 66),
            activeColor: const Color(0xFF14386E),
            tabBackgroundColor: const Color(0xFF14386E).withOpacity(0.1),
            gap: 8,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.list,
                text: 'Applications',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
            selectedIndex: 1,
                        onTabChange: (index) {
                          setState(
                            () {
                              selectedIndex =
                                  index; // Update the selected index
                            },
                          );
                          if (index == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    OffersScreen(email: widget.email),
                              ),
                            );
                          }
                          else if (index == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ApplicationsScreen(email: widget.email),
                              ),
                            );
                          }
                          else if (index == 2) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(email: widget.email),
                              ),
                            );
                          }
                          },
                      ),
                    ),
                    ),
    );
    
  }
}





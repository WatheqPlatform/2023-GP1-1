// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:watheq/Applications_Screen.dart';
import 'package:watheq/database_connection/connection.dart';
import 'package:watheq/profile_screen.dart';
import 'offer_details_screen.dart';

class OffersScreen extends StatefulWidget {
  final String email;

  const OffersScreen({super.key, required this.email});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String Name = "";
  List allOffers = [];
  List foundOffers = [];
  String SelectedCity = "";

  Map<String, List<String>> selectedChips = {
    'cities': [],
    'jobTitles': [],
    'companies': [],
    'industries': [],
    'employmentTypes': []
  };

  List<String> cityNames = [];
  List<String> companyNames = [];
  List<String> employmentTypes = [];
  List<String> industries = [];
  List<String> jobTitles = [];
  Map<int, int> experienceMap = {};

  Map<String, bool> chipSelectionState = {};

  double currentmin = 0;
  double currentmax = 50;
  RangeValues currentRangeValues = const RangeValues(0, 50);

  bool showAllCityNames = false;
  bool showAllIndustries = false;
  bool showAllJobTitles = false;
  bool showAllEmploymentTypes = false;
  bool showAllCompanies = false;

  Future<void> getdata() async {
    var res = await http.post(
      Uri.parse(Connection.jobOffersData),
      body: {"email": widget.email},
    );

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      setState(() {
        allOffers.addAll(red);
        foundOffers.addAll(red);
      });
    }
  }

  Future<void> getfillters() async {
    var res = await http.get(Uri.parse(Connection.filteredData));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      setState(() {
        for (var item in red) {
          if (item.containsKey("CityName")) {
            cityNames.add(item["CityName"]);
          } else if (item.containsKey("CompanyName")) {
            companyNames.add(item["CompanyName"]);
          } else if (item.containsKey("EmploymentType")) {
            employmentTypes.add(item["EmploymentType"]);
          } else if (item.containsKey("JobTitle")) {
            jobTitles.add(item["JobTitle"]);
          } else if (item.containsKey("CategoryName")) {
            industries.add(item["CategoryName"]); //categoty
          }

          if (item.containsKey("OfferID")) {
            int offerId = int.parse(item["OfferID"].toString());
            int experienceYears = item.containsKey("ExperienceYears")
                ? int.parse(item["ExperienceYears"].toString())
                : 0;
            experienceMap[offerId] = experienceYears;
          }
        }
      });
    }
  }

  Future getName() async {
    var response = await http.post(
      Uri.parse(Connection.jobSeekerName),
      body: {
        "email": widget.email,
      },
    );

    if (response.statusCode == 200) {
      var nameRespose = json.decode(response.body);
      String fullName = nameRespose[0]["Name"];

      int space = fullName.indexOf(" ");

      setState(() {
        if (space != -1) {
          Name = fullName.substring(0, space);
        } else {
          Name = fullName;
        }
        Name = Name.capitalizeEach();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    getName();
    getfillters();
    selectedChips = {
      'cities': [],
      'jobTitles': [],
      'companies': [],
      'industries': [],
      'employmentTypes': []
    };
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
              (element["CategoryName"]
                  .toLowerCase()
                  .contains(searchedWord.toLowerCase())))
          .toList();
    }

    setState(() {
      foundOffers = results;
    });
  }

  void filter(Map<String, List<String>> selectedLabelsMap) {
    List results = [];

    results = allOffers.where((element) {
      bool labelMatch = true;

      // Check each field
      selectedLabelsMap.forEach((category, labels) {
        if (labels.isNotEmpty) {
          switch (category) {
            case 'cities':
              labelMatch = labelMatch && labels.contains(element['CityName']);
              break;
            case 'jobTitles':
              labelMatch = labelMatch && labels.contains(element['JobTitle']);
              break;
            case 'companies':
              labelMatch =
                  labelMatch && labels.contains(element['CompanyName']);
              break;
            case 'industries':
              labelMatch =
                  labelMatch && labels.contains(element['CategoryName']);
              break;
            case 'employmentTypes':
              labelMatch =
                  labelMatch && labels.contains(element['EmploymentType']);
              break;
          }
        }
      });

      bool experienceMatch = false;
      if (experienceMap.isNotEmpty) {
        int offerId = int.parse(element['OfferID'].toString());
        int experienceYears = experienceMap[offerId] ?? 0;
        experienceMatch = experienceYears >= currentRangeValues.start &&
            experienceYears <= currentRangeValues.end;
      }

      return labelMatch && experienceMatch;
    }).toList();

    setState(() {
      foundOffers = results;
    });
  }

  void handleChipSelection(String category, String label, bool isSelected) {
    setState(() {
      chipSelectionState['$category|$label'] = isSelected;
    });
  }

  void resetFilters() {
    setState(() {
      selectedChips = {
        'cities': [],
        'jobTitles': [],
        'companies': [],
        'industries': [],
        'employmentTypes': []
      };
      chipSelectionState.clear();
      foundOffers = allOffers;
      double currentmin = 0;
      double currentmax = 50;
      currentRangeValues = RangeValues(currentmin, currentmax);
      showAllIndustries = false;
      showAllCityNames = false;
      showAllCompanies = false;
      showAllEmploymentTypes = false;
      showAllJobTitles = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int selectedIndex = 0;
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          "Hello " + Name + "!",
                          style: const TextStyle(
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
                          onPressed: () {}),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            // Initialize chipSelectionState based on selectedChips
                            chipSelectionState.clear();
                            selectedChips.forEach((category, labels) {
                              for (var label in labels) {
                                chipSelectionState['$category|$label'] = true;
                              }
                            });
                          });
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25))),
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (
                                    BuildContext context,
                                    StateSetter setState,
                                  ) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15.0,
                                            top: 10,
                                            bottom: 10,
                                            right: 15.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: const Icon(Icons.close),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 38.0,
                                                ),
                                                child: Text(
                                                  "Filter",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  resetFilters();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  "Reset",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 7.0,
                                                    ),
                                                    child: Text(
                                                      "City",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF024A8D),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 3.0,
                                                    ),
                                                    child: Wrap(
                                                      spacing:
                                                          8.0, // gap between adjacent chips
                                                      runSpacing:
                                                          0.5, // gap between lines
                                                      children:
                                                          List<Widget>.generate(
                                                        showAllCityNames
                                                            ? cityNames.length
                                                            : min(
                                                                cityNames
                                                                    .length,
                                                                3),
                                                        (int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child:
                                                                CustomChoiceChip(
                                                              label: cityNames[
                                                                  index],
                                                              category:
                                                                  'cities',
                                                              isSelected:
                                                                  chipSelectionState[
                                                                          'cities|${cityNames[index]}'] ??
                                                                      false,
                                                              onSelectionChanged:
                                                                  handleChipSelection,
                                                            ),
                                                          );
                                                        },
                                                      )..add(
                                                              cityNames.length >
                                                                      3
                                                                  ? GestureDetector(
                                                                      onTap: () =>
                                                                          setState(
                                                                        () {
                                                                          showAllCityNames =
                                                                              !showAllCityNames;
                                                                        },
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            showAllCityNames
                                                                                ? "Show less"
                                                                                : "Show more",
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color.fromARGB(255, 135, 135, 135),
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            showAllCityNames
                                                                                ? Icons.keyboard_arrow_up
                                                                                : Icons.keyboard_arrow_down,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                135,
                                                                                135,
                                                                                135),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 7.0,
                                                    ),
                                                    child: Text(
                                                      "Company",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF024A8D),
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 3.0,
                                                    ),
                                                    child: Wrap(
                                                      spacing:
                                                          8.0, // gap between adjacent chips
                                                      runSpacing:
                                                          1.0, // gap between lines
                                                      children:
                                                          List<Widget>.generate(
                                                        showAllCompanies
                                                            ? companyNames
                                                                .length
                                                            : min(
                                                                companyNames
                                                                    .length,
                                                                3),
                                                        (int index) {
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  CustomChoiceChip(
                                                                label:
                                                                    companyNames[
                                                                        index],
                                                                category:
                                                                    'companies',
                                                                isSelected:
                                                                    chipSelectionState[
                                                                            'companies|${companyNames[index]}'] ??
                                                                        false,
                                                                onSelectionChanged:
                                                                    handleChipSelection,
                                                              ));
                                                        },
                                                      )..add(companyNames
                                                                      .length >
                                                                  3
                                                              ? GestureDetector(
                                                                  onTap: () =>
                                                                      setState(
                                                                          () {
                                                                    showAllCompanies =
                                                                        !showAllCompanies;
                                                                  }),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        showAllCompanies
                                                                            ? "Show less"
                                                                            : "Show more",
                                                                        style:
                                                                            const TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              135,
                                                                              135,
                                                                              135),
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        showAllCompanies
                                                                            ? Icons.keyboard_arrow_up
                                                                            : Icons.keyboard_arrow_down,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container()),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 7.0,
                                                    ),
                                                    child: Text(
                                                      "Employment Type",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF024A8D),
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 3.0,
                                                    ),
                                                    child: Wrap(
                                                      spacing:
                                                          8.0, // gap between adjacent chips
                                                      runSpacing:
                                                          1.0, // gap between lines
                                                      children: List<
                                                              Widget>.generate(
                                                          showAllEmploymentTypes
                                                              ? employmentTypes
                                                                  .length
                                                              : min(
                                                                  employmentTypes
                                                                      .length,
                                                                  3),
                                                          (int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              CustomChoiceChip(
                                                            label:
                                                                employmentTypes[
                                                                    index],
                                                            category:
                                                                'employmentTypes',
                                                            isSelected:
                                                                chipSelectionState[
                                                                        'employmentTypes|${employmentTypes[index]}'] ??
                                                                    false,
                                                            onSelectionChanged:
                                                                handleChipSelection,
                                                          ),
                                                        );
                                                      })
                                                        ..add(employmentTypes
                                                                    .length >
                                                                3
                                                            ? GestureDetector(
                                                                onTap: () =>
                                                                    setState(
                                                                        () {
                                                                  showAllEmploymentTypes =
                                                                      !showAllEmploymentTypes;
                                                                }),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      showAllEmploymentTypes
                                                                          ? "Show less"
                                                                          : "Show more",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135),
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      showAllEmploymentTypes
                                                                          ? Icons
                                                                              .keyboard_arrow_up
                                                                          : Icons
                                                                              .keyboard_arrow_down,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          135,
                                                                          135,
                                                                          135),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Container()),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 7.0,
                                                    ),
                                                    child: Text(
                                                      "Job Title",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF024A8D),
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 3.0,
                                                    ),
                                                    child: Wrap(
                                                      spacing:
                                                          8.0, // gap between adjacent chips
                                                      runSpacing:
                                                          1.0, // gap between lines
                                                      children: List<
                                                              Widget>.generate(
                                                          showAllJobTitles
                                                              ? jobTitles.length
                                                              : min(
                                                                  jobTitles
                                                                      .length,
                                                                  3),
                                                          (int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              CustomChoiceChip(
                                                            label: jobTitles[
                                                                index],
                                                            category:
                                                                'jobTitles',
                                                            isSelected:
                                                                chipSelectionState[
                                                                        'jobTitles|${jobTitles[index]}'] ??
                                                                    false,
                                                            onSelectionChanged:
                                                                handleChipSelection,
                                                          ),
                                                        );
                                                      })
                                                        ..add(jobTitles.length >
                                                                3
                                                            ? GestureDetector(
                                                                onTap: () =>
                                                                    setState(
                                                                        () {
                                                                  showAllJobTitles =
                                                                      !showAllJobTitles;
                                                                }),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      showAllJobTitles
                                                                          ? "Show less"
                                                                          : "Show more",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135),
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      showAllJobTitles
                                                                          ? Icons
                                                                              .keyboard_arrow_up
                                                                          : Icons
                                                                              .keyboard_arrow_down,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          135,
                                                                          135,
                                                                          135),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Container()),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 7.0,
                                                    ),
                                                    child: Text(
                                                      "Industry",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF024A8D),
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 3.0,
                                                    ),
                                                    child: Wrap(
                                                      spacing:
                                                          8.0, // gap between adjacent chips
                                                      runSpacing:
                                                          1.0, // gap between lines
                                                      children: List<
                                                              Widget>.generate(
                                                          showAllIndustries
                                                              ? industries
                                                                  .length
                                                              : min(
                                                                  industries
                                                                      .length,
                                                                  3),
                                                          (int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              CustomChoiceChip(
                                                            label: industries[
                                                                index],
                                                            category:
                                                                'industries',
                                                            isSelected:
                                                                chipSelectionState[
                                                                        'industries|${industries[index]}'] ??
                                                                    false,
                                                            onSelectionChanged:
                                                                handleChipSelection,
                                                          ),
                                                        );
                                                      })
                                                        ..add(industries
                                                                    .length >
                                                                3
                                                            ? GestureDetector(
                                                                onTap: () =>
                                                                    setState(
                                                                        () {
                                                                  showAllIndustries =
                                                                      !showAllIndustries;
                                                                }),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      showAllIndustries
                                                                          ? "Show less"
                                                                          : "Show more",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            135,
                                                                            135,
                                                                            135),
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      showAllIndustries
                                                                          ? Icons
                                                                              .keyboard_arrow_up
                                                                          : Icons
                                                                              .keyboard_arrow_down,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          135,
                                                                          135,
                                                                          135),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Container()),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 7.0,
                                                    ),
                                                    child: Text(
                                                      "Experience Years",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF024A8D),
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  RangeSlider(
                                                    values: currentRangeValues,
                                                    min: currentmin,
                                                    max: currentmax,
                                                    divisions: (currentmax -
                                                            currentmin)
                                                        .toInt(),
                                                    labels: RangeLabels(
                                                      currentRangeValues.start
                                                          .round()
                                                          .toString(),
                                                      currentRangeValues.end
                                                          .round()
                                                          .toString(),
                                                    ),
                                                    onChanged:
                                                        (RangeValues values) {
                                                      setState(
                                                        () {
                                                          currentRangeValues =
                                                              values;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedChips = {
                                                'cities': [],
                                                'jobTitles': [],
                                                'companies': [],
                                                'industries': [],
                                                'employmentTypes': []
                                              };

                                              chipSelectionState
                                                  .forEach((key, isSelected) {
                                                if (isSelected) {
                                                  var parts = key.split('|');
                                                  selectedChips[parts[0]]
                                                      ?.add(parts[1]);
                                                }
                                              });

                                              filter(selectedChips);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF024A8D),
                                            fixedSize: Size(screenWidth * 0.91,
                                                screenHeight * 0.056),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: const Text(
                                            "Filter",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    );
                                  },
                                );
                              });
                        },
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: screenWidth * 0.809,
                        height: screenHeight * 0.045,
                        child: TextField(
                          onChanged: (value) => searchOffer(value),
                          decoration: InputDecoration(
                            hintText: "Search by title, industry, or company",
                            border: InputBorder.none,
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
              height: screenHeight * 0.815,
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
                  foundOffers.isEmpty
                      ? const Center(
                          // Display a message when their is no offers
                          child: Text('No job offers found.'),
                        )
                      : Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.73,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                              ),
                              child: ListView.builder(
                                itemCount: foundOffers.length,
                                padding: const EdgeInsets.only(
                                  top: 35,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2,
                                      left: 5,
                                      right: 5,
                                      bottom: 5,
                                    ),
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
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${foundOffers[index]["JobTitle"]}"
                                                        .capitalizeEach(),
                                                    style: const TextStyle(
                                                      color: Color(0xFF14386E),
                                                      fontSize: 21.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${foundOffers[index]["CompanyName"]} \n${foundOffers[index]["CategoryName"]}"
                                                        .capitalizeEach(),
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 155, 155, 155),
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
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: Text(
                                                      "Posted on ${foundOffers[index]["Date"]}"
                                                          .capitalizeEach(),
                                                      //"
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 155, 155, 155),
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 0,
                                                right: 5,
                                              ),
                                              width: screenWidth * 0.09,
                                              height: screenHeight * 0.058,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF024A8D),
                                                  width: 1.8,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_forward),
                                                iconSize: 20,
                                                onPressed: () {
                                                  Get.to(
                                                    () => JobOfferDetailScreen(
                                                      offerID:
                                                          foundOffers[index]
                                                              ["OfferID"],
                                                      email: widget.email,
                                                    ),
                                                  );
                                                },
                                                color: const Color(0xFF024A8D),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    width: 350,
                    margin: EdgeInsets.only(
                      left: screenWidth * 0.07,
                      top: screenHeight * 0.735,
                      bottom: 3,
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
                    //Bottom Menu
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: GNav(
                        backgroundColor: const Color.fromARGB(
                            0, 255, 255, 255), //Navigation Background
                        color: const Color.fromARGB(
                            255, 66, 66, 66), //Unslected page icon color
                        activeColor:
                            const Color(0xFF14386E), //Selected page icon color
                        tabBackgroundColor: const Color(0xFF14386E).withOpacity(
                            0.1), //Selected page icon background color
                        gap: 8,
                        iconSize: 24, // tab button icon size
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ), // navigation bar padding
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
                          )
                        ],
                        selectedIndex: 0,
                        onTabChange: (index) {
                          setState(
                            () {
                              selectedIndex =
                                  index; // Update the selected index
                            },
                          );
                          if (index == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ApplicationsScreen(email: widget.email),
                              ),
                            );
                          } else if (index == 2) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomChoiceChip extends StatefulWidget {
  final String label;
  final String category;
  final Function(String, String, bool) onSelectionChanged;
  bool isSelected;

  CustomChoiceChip({
    super.key,
    required this.label,
    required this.category,
    required this.onSelectionChanged,
    this.isSelected = false,
  });

  @override
  _CustomChoiceChipState createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.label),
      selected: widget.isSelected ?? false,
      onSelected: (bool selected) {
        setState(() {
          widget.isSelected = selected;
          widget.onSelectionChanged(widget.category, widget.label, selected);
        });
      },
      avatar: widget.isSelected
          ? const Icon(Icons.close, size: 18.0)
          : const Icon(Icons.add, size: 18.0),
      selectedColor: Colors.grey[400],
      backgroundColor: Colors.grey[300],
    );
  }
}

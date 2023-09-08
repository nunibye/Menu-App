// Loads the Home Page to display College tiles and Summary below.

import 'dart:async';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';
import 'main.dart' as main_page;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> colleges = [];

  // Function to load [colleges] list with SharedPreferences [prefs] hall disolay order.
  void getCollegeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString('collegesString');

    if (text == null) {
      List<String> textList = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];
      setState(() {
        colleges = textList;
      });
    } else if (text.split(',').length == 4) {
      List<String> textList = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];
      setState(() {
        colleges = textList;
      });
    } else {
      List<String> textList = text.split(',');
      setState(() {
        colleges = textList;
      });
    }
  }

  // Function to return the [index] of [college] to display correct page onTap.
  getIndex(college) {
    if (college == "Nine") {
      return 3;
    } else if (college == "Cowell") {
      return 2;
    } else if (college == "Porter") {
      return 4;
    } else if (college == "Oakes") {
      return 5;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    getCollegeOrder(); // Get SharedPreferences [prefs] for correct display order.
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildSummary(
      String college, Future<List<main_page.FoodCategory>> hallSummary) {
    int index = 0;
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
      alignment: Alignment.topLeft,
      child: FutureBuilder<List<main_page.FoodCategory>>(
        future: hallSummary,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final foodCategories = snapshot.data;

            return TextButton(
              // Give each [college] a button to lead to the full summary page.
              onPressed: () {
                index = getIndex(college.trim());
                main_page.scakey.currentState
                    ?.onItemTapped(index, constants.aniLength);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 30, 30, 30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: constants.borderWidth,
                          color: Color(constants.darkGray),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 8, bottom: constants.containerPaddingTitle),
                    alignment: Alignment.topLeft,
                    child: Text(college, style: constants.ContainerTextStyle),
                  ),

                  // Display all the food categories and items.
                  for (var foodCategory in foodCategories!)
                    if (foodCategory.foodItems.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var foodItem in foodCategory.foodItems)
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                foodItem,
                                textAlign: TextAlign.left,
                                style: constants.ContainerTextStyle.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: constants.bodyFont,
                                  fontSize: constants.bodyFontSize,
                                  height: constants.bodyFontheight,
                                ),
                              ),
                            ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.only(
                            top: constants.containerPaddingbody),
                        alignment: Alignment.center,
                        child: Text(
                          "Hall Closed",
                          textAlign: TextAlign.center,
                          style: constants.ContainerTextStyle.copyWith(
                            fontFamily: constants.bodyFont,
                            fontSize: constants.bodyFontSize,
                            height: constants.bodyFontheight,
                          ),
                        ),
                      )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: const TextStyle(
                fontSize: 25,
                color: Color(constants.yellowGold),
              ),
            );
          } else {
            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double iconSizeCollege = MediaQuery.of(context).size.width / 2.7;
    final time = DateTime.now();
    String mealTime = '';

    if (time.hour <= 4 || time.hour >= 23) {
      mealTime = 'Null';
    } else if (time.hour < 10 && time.hour > 4) {
      mealTime = 'Breakfast';
    } else if (time.hour < 16) {
      mealTime = 'Lunch';
    } else if (time.hour < 20) {
      mealTime = 'Dinner';
    } else if (time.hour < 23) {
      mealTime = 'Late Night';
    }

    return Scaffold(
      // Display app bar header.
      drawer: const NavDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color(constants.darkBlue),
        surfaceTintColor: const Color.fromARGB(255, 60, 60, 60),
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "UC Santa Cruz",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 40,
                fontFamily: 'Monoton',
                color: Color(constants.yellowGold)),
          ),
        ),
        shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
      ), // TODO: Make a refresh AND/OR create listeners (i have a copy of the file where it works)
      body: ListView(
        children: <Widget>[
          // Display header text.
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 40, left: 12),
            child: const Text(
              "Dining Halls",
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Montserat',
                  fontWeight: FontWeight.w800,
                  color: Color(constants.yellowOrange)),
            ),
          ),
          // Display all hall icons.
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.width / 2.3,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Loop through every college in [colleges].
                for (var i = 0; i < colleges.length; i++)
                  // Special formatting for first Icon.
                  if (i == 0)
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      // Icon button leads to specified [colleges] page.
                      child: IconButton(
                        onPressed: () {
                          main_page.scakey.currentState?.onItemTapped(
                              getIndex(colleges[i].trim()),
                              constants.aniLength);
                        },
                        icon: Image.asset('images/${colleges[i].trim()}.png'),
                        iconSize: iconSizeCollege,
                      ),
                    )
                  // Special formatting for last Icon.
                  else if (i == colleges.length - 1)
                    Container(
                      padding: const EdgeInsets.only(right: 7),
                      child: IconButton(
                        onPressed: () {
                          main_page.scakey.currentState?.onItemTapped(
                              getIndex(colleges[i].trim()),
                              constants.aniLength);
                        },
                        icon: Image.asset('images/${colleges[i].trim()}.png'),
                        iconSize: iconSizeCollege,
                      ),
                    )
                  // Icon formatting.
                  else
                    IconButton(
                      onPressed: () {
                        main_page.scakey.currentState?.onItemTapped(
                            getIndex(colleges[i].trim()), constants.aniLength);
                      },
                      icon: Image.asset('images/${colleges[i].trim()}.png'),
                      iconSize: iconSizeCollege,
                    ),
              ],
            ),
          ),

          // Displays summary for every college in [colleges].
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                for (var i = 0; i < colleges.length; i++)
                  buildSummary(
                      colleges[i].trim(),
                      main_page.fetchSummary(colleges[i].trim(), mealTime)),
                // Provide when the menu was last updated.
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Last updated: ${time.toString().substring(5, 19)}\nData provided by nutrition.sa.ucsc.edu",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

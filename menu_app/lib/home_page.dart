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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late Future futureAlbum;
  late Future nineSummary;
  late Future cowellSummary;
  late Future merrillSummary;
  late Future porterSummary;
  late Future oakesSummary;
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
    } else {
      List<String> textList = text.split(',');
      setState(() {
        colleges = textList;
      });
    }
  }

  // Function to return the [hallSummary] for each college
  getSummary(college) {
    if (college == 'Merrill') {
      return merrillSummary;
    } else if (college == 'Cowell') {
      return cowellSummary;
    } else if (college == 'Nine') {
      return nineSummary;
    } else if (college == 'Oakes') {
      return oakesSummary;
    } else {
      return porterSummary;
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

  setSummaries() {
    final time = DateTime.now();
    // Set each [collegeSummary] with a summary of food based on the time of day.
    //
    // FIXME: there has got to be a better way to do this in less lines. Perhaps
    // FIXME: a list with nested for loop.
    if (time.hour <= 4 || time.hour >= 23) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Late%20Night', cat: '*FIXME*');
      cowellSummary = nineSummary;
      merrillSummary = nineSummary;
      porterSummary = nineSummary;
      oakesSummary = nineSummary;
    } else if (time.hour < 10 && time.hour > 4) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Breakfast', cat: '*Breakfast*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Breakfast', cat: '*Breakfast*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Breakfast', cat: '*Breakfast*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Breakfast', cat: '*Breakfast*');
      oakesSummary =
          main_page.fetchAlbum('Oakes', 'Breakfast', cat: '*Breakfast*');
    } else if (time.hour < 16) {
      nineSummary = main_page.fetchAlbum('Nine', 'Lunch', cat: '*Open%20Bars*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Lunch', cat: '*Open%20Bars*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Lunch', cat: '*Open%20Bars*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Lunch', cat: '*Open%20Bars*');
      oakesSummary =
          main_page.fetchAlbum('Oakes', 'Lunch', cat: '*Open%20Bars*');
    } else if (time.hour < 20) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Dinner', cat: '*Open%20Bars*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Dinner', cat: '*Open%20Bars*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Dinner', cat: '*Open%20Bars*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Dinner', cat: '*Open%20Bars*');
      oakesSummary =
          main_page.fetchAlbum('Oakes', 'Dinner', cat: '*Open%20Bars*');
    } else if (time.hour < 23) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Late%20Night', cat: '*Open%20Bars*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Late%20Night', cat: '*Open%20Bars*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Late%20Night', cat: '*Open%20Bars*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Late%20Night', cat: '*Open%20Bars*');
      oakesSummary =
          main_page.fetchAlbum('Oakes', 'Late%20Night', cat: '*Open%20Bars*');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getCollegeOrder(); // Get SharedPreferences [prefs] for correct display order.
    setSummaries();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//TODO: ELI PLS FIX THIS :)
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // print('state = $state');
  //   // if (state == AppLifecycleState.inactive) {
  //   //    // app transitioning to other state.
  //   // } else if (state == AppLifecycleState.paused) {
  //   //    // app is on the background.
  //   // } else if (state == AppLifecycleState.detached) {
  //   //    // flutter engine is running but detached from views
  //   // } else if (state == AppLifecycleState.resumed) {
  //   //    // app is visible and running.
  //   //    // run your App class again
  //   if (state == AppLifecycleState.resumed) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (BuildContext context) => super.widget));
  //   }
  // }

  // Builds the [college]'s summary based on [hallSummary] list of items.
  Widget buildSummary(college, Future<dynamic> hallSummary) {
    int index = 0;
    return Container(
      alignment: Alignment.topLeft,
      child: FutureBuilder(
        future: hallSummary,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: constants.borderWidth,
                                color: Color(constants.darkGray)))),
                    padding:
                        const EdgeInsets.all(constants.containerPaddingTitle),
                    alignment: Alignment.topLeft,
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 40),
                          alignment: Alignment.topLeft),

                      // Give each [college] a button to lead to full summary page.
                      onPressed: () => {
                        if (college == "Nine")
                          {
                            index = 3,
                          }
                        else if (college == "Cowell")
                          {
                            index = 2,
                          }
                        else if (college == "Porter")
                          {
                            index = 4,
                          }
                        else if (college == "Oakes")
                          {
                            index = 5,
                          }
                        else
                          {
                            index = 1,
                          },
                        main_page.scakey.currentState?.onItemTapped(index),
                      },

                      // College name as a button title.
                      child: Text(
                        "$college",
                        style: const TextStyle(
                          fontFamily: constants.titleFont,
                          fontWeight: FontWeight.bold,
                          fontSize: constants.titleFontSize,
                          color: Color(constants.titleColor),
                          height: constants.titleFontheight,
                        ),
                      ),
                    )),

                // If no data is passed in, default to ["Hall Closed"] text.
                if (snapshot.data[0] == 'null')
                  Container(
                      padding:
                          const EdgeInsets.all(constants.containerPaddingbody),
                      alignment: Alignment.center,
                      child: const Text(
                        "Hall Closed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: constants.bodyFont,
                            //fontWeight: FontWeight.bold,
                            fontSize: constants.bodyFontSize,
                            color: Color(constants.bodyColor),
                            height: constants.bodyFontheight,
                            fontWeight: FontWeight.bold),
                      ))

                // Display all the food as a list.
                else
                  for (var i = 0; i < snapshot.data.length; i++)
                    (Container(
                      padding: const EdgeInsets.only(left: 27),
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data[i],
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontFamily: constants.bodyFont,
                          fontSize: constants.bodyFontSize,
                          color: Color(constants.bodyColor),
                          height: constants.bodyFontheight,
                        ),
                      ),
                    )),
              ],
            );

            // Display error message if there is an error.
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: const TextStyle(
                fontSize: 25,
                color: Color(constants.yellowGold),
              ),
            );
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double iconSizeCollege = MediaQuery.of(context).size.width / 2.7;
    var timeFetch = DateTime.now();
    String time = timeFetch.toString().substring(5, 19);

    return Scaffold(
      // Display app bar header.
      drawer: const NavDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color(constants.darkBlue),
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
      ),
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
                            main_page.scakey.currentState
                                ?.onItemTapped(getIndex(colleges[i].trim()));
                          },
                          icon: Image.asset('images/${colleges[i].trim()}.png'),
                          iconSize: iconSizeCollege,
                        ))

                  // Special formatting for last Icon.
                  else if (i == colleges.length - 1)
                    Container(
                        padding: const EdgeInsets.only(right: 7),
                        child: IconButton(
                          onPressed: () {
                            main_page.scakey.currentState
                                ?.onItemTapped(getIndex(colleges[i].trim()));
                          },
                          icon: Image.asset('images/${colleges[i].trim()}.png'),
                          iconSize: iconSizeCollege,
                        ))

                  // Icon formatting.
                  else
                    (IconButton(
                      onPressed: () {
                        main_page.scakey.currentState
                            ?.onItemTapped(getIndex(colleges[i].trim()));
                      },
                      icon: Image.asset('images/${colleges[i].trim()}.png'),
                      iconSize: iconSizeCollege,
                    ))
              ],
            ),
          ),

          // Displays summary for every college in [colleges].
          Container(
            alignment: Alignment.topLeft,
            child: FutureBuilder(
              builder: (context, snapshot) {
                return Column(
                  children: [
                    for (var i = 0; i < colleges.length; i++)
                      buildSummary(colleges[i].trim(), getSummary(colleges[i])),

                    // Provide when menu was last updated.
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                          "Last updated: $time\nData provided by nutrition.sa.ucsc.edu",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(height: 70),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

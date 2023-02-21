import 'dart:async';

//import 'package:flutter/foundation.dart';
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
  late Future futureAlbum;
  late Future nineSummary;
  late Future cowellSummary;
  late Future merrillSummary;
  late Future porterSummary;
  List<String> colleges = [];
  void getCollegeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString('collegesString');

    if (text == null) {
      List<String> textList = ['Merrill', 'Cowell', 'Nine', 'Porter'];
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

  getSummary(college) {
    if (college == 'Merrill') {
      return merrillSummary;
    } else if (college == 'Cowell') {
      return cowellSummary;
    } else if (college == 'Nine') {
      return nineSummary;
    } else {
      return porterSummary;
    }
  }

  getIndex(college) {
    if (college == "Nine") {
      return 3;
    } else if (college == "Cowell") {
      return 2;
    } else if (college == "Porter") {
      return 4;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    final time = DateTime.now();
    getCollegeOrder();
    //FIXME goofy a code
    if (time.hour <= 4 || time.hour >= 23) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Late%20Night', cat: '*FIXME*');
      cowellSummary = nineSummary;
      merrillSummary = nineSummary;
      porterSummary = nineSummary;
    } else if (time.hour < 10 && time.hour > 4) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Breakfast', cat: '*Breakfast*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Breakfast', cat: '*Breakfast*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Breakfast', cat: '*Breakfast*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Breakfast', cat: '*Breakfast*');
    } else if (time.hour < 16) {
      nineSummary = main_page.fetchAlbum('Nine', 'Lunch', cat: '*Open%20Bars*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Lunch', cat: '*Open%20Bars*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Lunch', cat: '*Open%20Bars*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Lunch', cat: '*Open%20Bars*');
    } else if (time.hour < 20) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Dinner', cat: '*Open%20Bars*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Dinner', cat: '*Open%20Bars*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Dinner', cat: '*Open%20Bars*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Dinner', cat: '*Open%20Bars*');
    } else if (time.hour < 23) {
      nineSummary =
          main_page.fetchAlbum('Nine', 'Late%20Night', cat: '*Open%20Bars*');
      cowellSummary =
          main_page.fetchAlbum('Cowell', 'Late%20Night', cat: '*Open%20Bars*');
      merrillSummary =
          main_page.fetchAlbum('Merrill', 'Late%20Night', cat: '*Open%20Bars*');
      porterSummary =
          main_page.fetchAlbum('Porter', 'Late%20Night', cat: '*Open%20Bars*');
    }
  }

  Widget buildSummary(college, Future<dynamic> hallSummary) {
    int index = 0;
    return Container(
      alignment: Alignment.topLeft,
      //padding: const EdgeInsets.only(top: 20, left: 12),
      child: FutureBuilder(
        future: hallSummary,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                //padding: const EdgeInsets.all(4),
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
                        else
                          {
                            index = 1,
                          },
                        main_page.scakey.currentState?.onItemTapped(index),
                      },
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
                else
                  for (var i = 0; i < snapshot.data.length; i++)
                    (Container(
                      padding:
                          // const EdgeInsets.all(
                          //     constants.containerPaddingbody),
                          const EdgeInsets.only(right: 10),
                      alignment: Alignment.topRight,
                      child: Text(
                        snapshot.data[i],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: constants.bodyFont,
                          //fontWeight: FontWeight.bold,
                          fontSize: constants.bodyFontSize,
                          color: Color(constants.bodyColor),
                          height: constants.bodyFontheight,
                        ),
                      ),
                    )),
              ],
            );
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

    return Scaffold(
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
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.width / 2.3,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < colleges.length; i++)
                  if (i == 0)
                    Container(
                        padding: const EdgeInsets.only(left: 7),
                        child: IconButton(
                          onPressed: () {
                            main_page.scakey.currentState
                                ?.onItemTapped(getIndex(colleges[i].trim()));
                          },
                          icon: Image.asset(
                              'images/' + (colleges[i].trim()) + '.png'),
                          iconSize: iconSizeCollege,
                        ))
                  else if (i == colleges.length - 1)
                    Container(
                        padding: const EdgeInsets.only(right: 7),
                        child: IconButton(
                          onPressed: () {
                            main_page.scakey.currentState
                                ?.onItemTapped(getIndex(colleges[i].trim()));
                          },
                          icon: Image.asset(
                              'images/' + (colleges[i].trim()) + '.png'),
                          iconSize: iconSizeCollege,
                        ))
                  else
                    (IconButton(
                      onPressed: () {
                        main_page.scakey.currentState
                            ?.onItemTapped(getIndex(colleges[i].trim()));
                      },
                      icon: Image.asset(
                          'images/' + (colleges[i].trim()) + '.png'),
                      iconSize: iconSizeCollege,
                    ))
                // IconButton(
                //   onPressed: () {
                //     main_page.scakey.currentState?.onItemTapped(2);
                //   },
                //   icon: Image.asset('images/cowell2.png'),
                //   iconSize: iconSizeCollege,
                // ),
                // IconButton(
                //   onPressed: () {
                //     main_page.scakey.currentState?.onItemTapped(3);
                //   },
                //   icon: Image.asset('images/nine2.png'),
                //   iconSize: iconSizeCollege,
                // ),
                // IconButton(
                //   onPressed: () {
                //     main_page.scakey.currentState?.onItemTapped(4);
                //   },
                //   icon: Image.asset('images/porter2.png'),
                //   iconSize: iconSizeCollege,
                // ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            // height: MediaQuery.of(context).size.height / 2,
            //padding: const EdgeInsets.only(top: 20, left: 12),
            child: FutureBuilder(
              // future: nineSummary,
              builder: (context, snapshot) {
                // if (snapshot.hasData) {
                return Column(
                  children: [
                    for (var i = 0; i < colleges.length; i++)
                      buildSummary(colleges[i].trim(), getSummary(colleges[i])),
                    const SizedBox(height: 70),
                  ],
                );
                // } else if (snapshot.hasError) {
                //   return Text(
                //     '${snapshot.error}',
                //     style: const TextStyle(
                //       fontSize: 25,
                //       color: Color(constants.yellowGold),
                //     ),
                //   );
                // }

                // By default, show a loading spinner.
              },
            ),
          ),
        ],
      ),
    );
  }
}

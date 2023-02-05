import 'dart:async';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/cowell_menu.dart';
import 'package:menu_app/merrill_menu.dart';
import 'package:menu_app/nine_menu.dart';
import 'package:menu_app/porter_menu.dart';
import 'package:http/http.dart' as http;
//import 'package:google_mobile_ads/google_mobile_ads.dart';
buildMeal(Future<dynamic> hallSummary) {
    return Container(
      alignment: Alignment.topLeft,
      //padding: const EdgeInsets.only(top: 20, left: 12),
      child: FutureBuilder(
        future: hallSummary,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data[0].toString() == 'null') {
              return Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: constants.borderWidth,
                            color: Color(constants.darkGray)))),
                padding: const EdgeInsets.all(constants.containerPaddingTitle),
                alignment: Alignment.topCenter,
                child: const Text(
                  'Unavailable Today',
                  style: TextStyle(
                    fontFamily: constants.titleFont,
                    fontWeight: FontWeight.bold,
                    fontSize: constants.titleFontSize,
                    color: Color(constants.titleColor),
                    height: constants.titleFontheight,
                  ),
                ),
              );
            }else{
            return ListView(
              //padding: const EdgeInsets.all(4),
              children: [
                for (var i = 0; i < snapshot.data.length; i++)
                  if (i % 2 == 0)
                    (Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: constants.borderWidth,
                                  color: Color(constants.darkGray)))),
                      padding:
                          const EdgeInsets.all(constants.containerPaddingTitle),
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data[i],
                        style: const TextStyle(
                          fontFamily: constants.titleFont,
                          fontWeight: FontWeight.bold,
                          fontSize: constants.titleFontSize,
                          color: Color(constants.titleColor),
                          height: constants.titleFontheight,
                        ),
                      ),
                    ))
                  else
                    (Container(
                        padding: const EdgeInsets.all(
                            constants.containerPaddingbody),
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
                        )))
              ],
            );}
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
Future fetchAlbum(college, meal, {cat = ""}) async {
  final response = await http.get(Uri.parse(
      'https://ucsc-menu-app-default-rtdb.firebaseio.com/$college/$meal/$cat.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var list = response.body.toString().split('*');
    list.remove('{"');

    for (var i = 0; i < list.length; i++) {
      if (i % 2 == 0) {
        list[i] = list[i].replaceAll(RegExp(r'[^\w\s]+'), '');
      } else {
        String temp = list[i];
        //List temp_list = [];
        List listTemp = temp.split(',');
        listTemp.remove('"');
        //const String tab = '  ';
        for (var i = 0; i < listTemp.length; i++) {
          listTemp[i] = listTemp[i].replaceAll(RegExp(r'[^\w\s]+'), '');
          //listTemp[i] = '*' + listTemp[i];
        }
        temp = listTemp.join('\n');
        list[i] = temp;
      }
    }

    return list;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future fetchCat(college, meal, cat) async {
  final response = await http.get(Uri.parse(
      'https://ucsc-menu-app-default-rtdb.firebaseio.com/$college/$meal/$cat.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var list = response.body.toString().split(',');

    for (var i = 0; i < list.length; i++) {
      String temp = list[i];
      //List temp_list = [];
      List listTemp = temp.split(',');
      listTemp.remove('"');
      //const String tab = '  ';
      for (var i = 0; i < listTemp.length; i++) {
        listTemp[i] = listTemp[i].replaceAll(RegExp(r'[^\w\s]+'), '');
        //listTemp[i] = '*' + listTemp[i];
      }
      temp = listTemp.join('\n');
      list[i] = temp;
    }

    return list;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

//void main() => runApp(const MyApp());
void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialize();
  runApp(const MyApp());
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(constants.darkBlue),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPageIndex = 0;
  late Future futureAlbum;
  late Future nineSummary;
  late Future cowellSummary;
  late Future merrillSummary;
  late Future porterSummary;

  @override
  void initState() {
    super.initState();
    final time = DateTime.now();
    if (time.hour < 10 && time.hour > 4) {
      nineSummary = fetchCat('Nine', 'Breakfast', '*Breakfast*');
      cowellSummary = fetchCat('Cowell', 'Breakfast', '*Breakfast*');
      merrillSummary = fetchCat('Merrill', 'Breakfast', '*Breakfast*');
      porterSummary = fetchCat('Porter', 'Breakfast', '*Breakfast*');
    } else if (time.hour < 16) {
      nineSummary = fetchCat('Nine', 'Lunch', '*Open%20Bars*');
      cowellSummary = fetchCat('Cowell', 'Lunch', '*Open%20Bars*');
      merrillSummary = fetchCat('Merrill', 'Lunch', '*Open%20Bars*');
      porterSummary = fetchCat('Porter', 'Lunch', '*Open%20Bars*');
    } else if (time.hour < 20) {
      nineSummary = fetchCat('Nine', 'Dinner', '*Open%20Bars*');
      cowellSummary = fetchCat('Cowell', 'Dinner', '*Open%20Bars*');
      merrillSummary = fetchCat('Merrill', 'Dinner', '*Open%20Bars*');
      porterSummary = fetchCat('Porter', 'Dinner', '*Open%20Bars*');
    } else if (time.hour < 23){
      nineSummary = fetchCat('Nine', 'Late%20Night', '*Open%20Bars*');
      cowellSummary = fetchCat('Cowell', 'Late%20Night', '*Open%20Bars*');
      merrillSummary = fetchCat('Merrill', 'Late%20Night', '*Open%20Bars*');
      porterSummary = fetchCat('Porter', 'Late%20Night', '*Open%20Bars*');
      //FIXME goofy a code
    }else{
      nineSummary = fetchCat('Nine', 'Late%20Night', '*FIXME*');
      cowellSummary = nineSummary;
      merrillSummary = nineSummary;
      porterSummary = nineSummary;
      
    }

  }

  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum('Breakfast');
  // }
  
  Widget buildSummary(college, Future<dynamic> hallSummary) {
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
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            if (college == "Nine") {
                              return const NineMenu();
                            } else if (college == "Cowell") {
                              return const CowellMenu();
                            } else if (college == "Porter") {
                              return const PorterMenu();
                            } else {
                              return const MerrillMenu();
                            }
                          }),
                        )
                      },
                      child: Text(
                        "$college",
                        style: const TextStyle(
                          fontFamily: constants.titleFont,
                          fontWeight: FontWeight.bold,
                          fontSize: constants.titleFontSize - 5,
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
                        ),
                      ))
                else
                  for (var i = 0; i < snapshot.data.length; i++)
                    (Container(
                        padding: const EdgeInsets.all(
                            constants.containerPaddingbody - 2),
                        alignment: Alignment.topRight,
                        child: Text(
                          snapshot.data[i],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: constants.bodyFont,
                            //fontWeight: FontWeight.bold,
                            fontSize: constants.bodyFontSize - 2,
                            color: Color(constants.bodyColor),
                            height: constants.bodyFontheight,
                          ),
                        )))
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
    double iconSizeCollege = MediaQuery.of(context).size.height / 6;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: const Color(constants.darkBlue),
          title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "UC Santa Cruz",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Monoton',
                  color: Color(constants.yellowGold)),
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        ),
        body: ListView(children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 40, left: 12),
            child: const Text(
              "Dining Halls",
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Montserat',
                  fontWeight: FontWeight.bold,
                  color: Color(constants.yellowOrange)),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height / 5,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const MerrillMenu();
                      }),
                    );
                  },
                  icon: Image.asset('images/merrill2.png'),
                  iconSize: iconSizeCollege,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const CowellMenu();
                      }),
                    );
                  },
                  icon: Image.asset('images/cowell2.png'),
                  iconSize: iconSizeCollege,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const NineMenu();
                      }),
                    );
                  },
                  icon: Image.asset('images/nine2.png'),
                  iconSize: iconSizeCollege,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const PorterMenu();
                      }),
                    );
                  },
                  icon: Image.asset('images/porter2.png'),
                  iconSize: iconSizeCollege,
                ),
              ],
            ),
          ),

          // Container(
          //   alignment: Alignment.bottomCenter,
          //   height: MediaQuery.of(context).size.height / 4,
          //   child: const Text(
          //     "More Coming Soon Here",
          //     style: TextStyle(
          //         fontSize: 25,
          //         fontFamily: 'Montserat',
          //         fontWeight: FontWeight.bold,
          //         color: Color(constants.white)),
          //   ),
          // ),
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
                    buildSummary("Porter", porterSummary),
                    buildSummary("Nine", nineSummary),
                    buildSummary("Cowell", cowellSummary),
                    buildSummary("Merrill", merrillSummary),
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
        ])

        // Container(
        //   alignment: Alignment.topLeft,
        //   padding: const EdgeInsets.only(top: 20, left: 12),
        //   child: FutureBuilder(
        //     future: futureAlbum,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return Text(
        //           snapshot.data[1],
        //           style: const TextStyle(
        //               fontSize: 25, color: Color(constants.yellowGold)),
        //         );
        //       } else if (snapshot.hasError) {
        //         return Text(
        //           '${snapshot.error}',
        //           style: const TextStyle(
        //               fontSize: 25, color: Color(constants.yellowGold)),
        //         );
        //       }

        //       // By default, show a loading spinner.
        //       return const CircularProgressIndicator();
        //     },
        //   ),
        // )

        );
  }
}

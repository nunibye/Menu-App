import 'dart:async';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/cowell_menu.dart';
import 'package:menu_app/merrill_menu.dart';
import 'package:menu_app/nine_menu.dart';
import 'package:menu_app/porter_menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart' as ad_helper;

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
          } else {
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
                        padding: const EdgeInsets.only(right: 10),
                        // const EdgeInsets.all(
                        //     constants.containerPaddingbody),
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
                        ))),
                const SizedBox(height: 80),
              ],
            );
          }
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

    // If there is a category
    if (cat != "") {
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

      // If fetching full meals
    } else {
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
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

//void main() => runApp(const MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  //MobileAds.instance.initialize();
  //runApp(const MyApp());
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ignores IOS set to bold text
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(boldText: false),
        child: child!,
      ),
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
  bool adLoaded = false;
  BannerAd? _bannerAd;

  //...

  //  Add _getDestinationItemIndex()
  // int _getDestinationItemIndex(int rawIndex) {
  //   if (_ad != null) {
  //     return rawIndex - 1;
  //   }
  //   return rawIndex;
  // }

  @override
  void initState() {
    super.initState();
    final time = DateTime.now();
    //FIXME goofy a code
    if (time.hour <= 4 || time.hour >= 23) {
      nineSummary = fetchAlbum('Nine', 'Late%20Night', cat: '*FIXME*');
      cowellSummary = nineSummary;
      merrillSummary = nineSummary;
      porterSummary = nineSummary;
    } else if (time.hour < 10 && time.hour > 4) {
      nineSummary = fetchAlbum('Nine', 'Breakfast', cat: '*Breakfast*');
      cowellSummary = fetchAlbum('Cowell', 'Breakfast', cat: '*Breakfast*');
      merrillSummary = fetchAlbum('Merrill', 'Breakfast', cat: '*Breakfast*');
      porterSummary = fetchAlbum('Porter', 'Breakfast', cat: '*Breakfast*');
    } else if (time.hour < 16) {
      nineSummary = fetchAlbum('Nine', 'Lunch', cat: '*Open%20Bars*');
      cowellSummary = fetchAlbum('Cowell', 'Lunch', cat: '*Open%20Bars*');
      merrillSummary = fetchAlbum('Merrill', 'Lunch', cat: '*Open%20Bars*');
      porterSummary = fetchAlbum('Porter', 'Lunch', cat: '*Open%20Bars*');
    } else if (time.hour < 20) {
      nineSummary = fetchAlbum('Nine', 'Dinner', cat: '*Open%20Bars*');
      cowellSummary = fetchAlbum('Cowell', 'Dinner', cat: '*Open%20Bars*');
      merrillSummary = fetchAlbum('Merrill', 'Dinner', cat: '*Open%20Bars*');
      porterSummary = fetchAlbum('Porter', 'Dinner', cat: '*Open%20Bars*');
    } else if (time.hour < 23) {
      nineSummary = fetchAlbum('Nine', 'Late%20Night', cat: '*Open%20Bars*');
      cowellSummary =
          fetchAlbum('Cowell', 'Late%20Night', cat: '*Open%20Bars*');
      merrillSummary =
          fetchAlbum('Merrill', 'Late%20Night', cat: '*Open%20Bars*');
      porterSummary =
          fetchAlbum('Porter', 'Late%20Night', cat: '*Open%20Bars*');
    }
    //bool adLoaded;
    _bannerAd = BannerAd(
      adUnitId: ad_helper.getAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          adLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          adLoaded = false;
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

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
    double iconSizeCollege = MediaQuery.of(context).size.height / 6;
    List<Widget> bottomBar = [];
    bottomBar.add(Container(
      height: 50.0,
    ));
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
                fontWeight: FontWeight.normal,
                fontSize: 40,
                fontFamily: 'Monoton',
                color: Color(constants.yellowGold)),
          ),
        ),
        shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
      ),
      persistentFooterButtons: bottomBar,
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: ListView(children: <Widget>[
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
            ]),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: SizedBox(
//             alignment: Alignment.center,
              width: _bannerAd?.size.width.toDouble(),
              height: _bannerAd?.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        ],
      ),
    );
  }
}
// Container(
//             alignment: Alignment.center,
//             width: _bannerAd?.size.width.toDouble(),
//             height: _bannerAd?.size.height.toDouble(),
//             child: AdWidget(ad: _bannerAd!),
//           ),
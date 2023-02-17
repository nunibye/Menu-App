import 'dart:async';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;

import 'package:menu_app/home_page.dart';
import 'package:menu_app/nine_menu.dart';
import 'package:menu_app/cowell_menu.dart';
import 'package:menu_app/porter_menu.dart';
import 'package:menu_app/merrill_menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart' as ad_helper;

//import 'package:google_mobile_ads/google_mobile_ads.dart';
buildMeal(Future<dynamic> hallSummary) {
  var timeFetch = DateTime.now();
  String time = timeFetch.toString().substring(5, 19);

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
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text("updated: $time",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.grey)),
                )
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
}

final scakey = GlobalKey<_RootPageState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Ignores IOS set to bold text
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(boldText: false),
        child: child!,
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(constants.darkBlue),
      ),
      home: RootPage(key: scakey),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late Future futureAlbum;
  late Future nineSummary;
  late Future cowellSummary;
  late Future merrillSummary;
  late Future porterSummary;
  bool adLoad = false;
  bool showAd = true;
  BannerAd? _bannerAd;
  int selectedIndex = 0;

//final myKey = GlobalKey<_RootPageState>();
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MerrillMenu(),
    const CowellMenu(),
    const NineMenu(),
    const PorterMenu(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (showAd == true) {
      _bannerAd = BannerAd(
        adUnitId: ad_helper.getAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        // size: AdSize.getAnchoredAdaptiveBannerAdSize(Orientation.landscape, 100),  //FIXME: try something with adaptive size?

        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            adLoad = true;
            setState(() {});
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            adLoad = false;
            setState(() {});
          },
        ),
      );

      _bannerAd?.load();
    } else {
      _bannerAd = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  Widget bottomBar() {
    return SizedBox(
      //color: Colors.amber,
      // alignment: Alignment.center,
      width: _bannerAd?.size.width.toDouble(),
      height: _bannerAd?.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  @override
  Widget build(BuildContext context) {
    //bool adShown = false; enable to add a way to diable ads
    //double iconSizeCollege = MediaQuery.of(context).size.height / 6;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: adLoad ? bottomBar() : null,
    );
  }
}

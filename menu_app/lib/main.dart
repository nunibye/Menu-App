// MAIN program.

import 'dart:async';

import 'package:flutter/material.dart';
import 'constants.dart' as constants;

import 'package:menu_app/home_page.dart';
import 'package:menu_app/nine_menu.dart';
import 'package:menu_app/cowell_menu.dart';
import 'package:menu_app/porter_menu.dart';
import 'package:menu_app/merrill_menu.dart';

import 'package:menu_app/calculator.dart';
import 'package:menu_app/about_page.dart';
import 'package:menu_app/settings_page.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'ad_helper.dart' as ad_helper;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

// Function builds the dining hall's meal full summmary page.
buildMeal(Future<dynamic> hallSummary) {
  return Container(
    alignment: Alignment.topLeft,
    child: FutureBuilder(
      future: hallSummary,
      builder: (context, snapshot) {
        // Display the [hallSummary] data.
        if (snapshot.hasData) {
          // Display ['Unavailable Today'] if there is no data in [hallSummary].
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

            // Display the food category and food items.
          } else {
            return ListView(
              children: [
                // Loop though all food items.
                for (var i = 0; i < snapshot.data.length; i++)

                  // Display the food categories.
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

                  // Display the food items.
                  else
                    (Container(
                      padding: const EdgeInsets.only(right: 10),
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
                const SizedBox(height: 80),
              ],
            );
          }

          // If there is an error, display error.
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

  // If the server did return a 200 OK response,
  // then parse the JSON.
  if (response.statusCode == 200) {
    // If there is a category, there are only food items.
    // Therefore, split up just food items.
    if (cat != "") {
      var list = response.body.toString().split(',');

      // Loop through every item in the food list.
      for (var i = 0; i < list.length; i++) {
        // Clean up string.
        String temp = list[i];
        List listTemp = temp.split(',');
        listTemp.remove('"');
        for (var i = 0; i < listTemp.length; i++) {
          listTemp[i] = listTemp[i].replaceAll(RegExp(r'[^\w\s]+'), '');
        }
        // Rejoin into list [list].
        temp = listTemp.join('\n');
        list[i] = temp;
      }
      return list;

      // If fetching full meals with categories.
    } else {
      // Split between categories denoted with ['*']
      var list = response.body.toString().split('*');
      list.remove('{"');

      for (var i = 0; i < list.length; i++) {
        // Clean [category] string.
        if (i % 2 == 0) {
          list[i] = list[i].replaceAll(RegExp(r'[^\w\s]+'), '');
          // Clean food items.
        } else {
          String temp = list[i];
          List listTemp = temp.split(',');
          listTemp.remove('"');
          for (var i = 0; i < listTemp.length; i++) {
            listTemp[i] = listTemp[i].replaceAll(RegExp(r'[^\w\s]+'), '');
          }
          // Rejoin into list [list].
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

// Get the adBool and call [adLoader].
getAdBool() async {
  final prefs = await SharedPreferences.getInstance();
  bool? adBool = prefs.getBool('showAd');

  if (adBool == null || adBool == true) {
    adLoader();
  }
}

// Function to load ad.
void adLoader() async {
  AppLovinMAX.setHasUserConsent(false);
  AppLovinMAX.setIsAgeRestrictedUser(false);
  AppLovinMAX.setDoNotSell(true);
  Map? sdkConfiguration = await AppLovinMAX.initialize(
      'GFr_0T7XJkpH_DCfXDvsS60h31yU80TT5Luv56H6OglFi3tzt7SCQgZVD6nSJlvFCxyVoqCaS5drzhDtV1MKL0');
}

// MAIN function sets preferences.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getAdBool();

  //AppLovinMAX.showMediationDebugger();
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

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  late Future futureAlbum;
  late Future nineSummary;
  late Future cowellSummary;
  late Future merrillSummary;
  late Future porterSummary;
  bool adLoad = false;
  bool showAd = true; //FIXME: CHANGE TO TRUE FOR RELEASE.
  //BannerAd? _bannerAd;

  // Indicies of the app pages.
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MerrillMenu(),
    const CowellMenu(),
    const NineMenu(),
    const PorterMenu(),
    const Calculator(),
    const SettingsPage(),
    const AboutPage(),
  ];

  // Changes page based on icon selected [index].
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (selectedIndex != 0) {
      scakey.currentState?.onItemTapped(0);
      return true;
    } else {
      return false;
    }
    
  }

  double rh = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
                position: Tween(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation),
                child: child);
          },
          child: _widgetOptions.elementAt(selectedIndex),
        ),
      ),

      // AD bar.
      bottomNavigationBar: Container(
        //color: Colors.amber,
        alignment: Alignment.topCenter,

        height: rh,
        child: MaxAdView(
            adUnitId: ad_helper.getAdUnitId,
            adFormat: AdFormat.banner,
            listener: AdViewAdListener(
                onAdLoadedCallback: (ad) {
                  if (ad_helper.getDevice == 'android') {
                    setState(() {
                      rh = 50;
                    });
                  } else if (ad_helper.getDevice == 'ios') {
                    setState(() {
                      rh = 70;
                    });
                  }
                },
                onAdLoadFailedCallback: (adUnitId, error) {
                  setState(() {
                    rh = 0;
                  });
                },
                onAdClickedCallback: (ad) {},
                onAdExpandedCallback: (ad) {},
                onAdCollapsedCallback: (ad) {})),
      ),
    );
  }
}

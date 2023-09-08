// MAIN program.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:menu_app/widgets.dart';
import 'constants.dart' as constants;

import 'package:menu_app/home_page.dart';

import 'package:menu_app/calculator.dart';
import 'package:menu_app/about_page.dart';
import 'package:menu_app/settings_page.dart';

import 'package:flutter/services.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'ad_helper.dart' as ad_helper;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_database/firebase_database.dart';

//import 'package:google_mobile_ads/google_mobile_ads.dart';

Widget buildMeal(Future<List<FoodCategory>> hallSummary) {
  return Container(
    padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
    alignment: Alignment.topLeft,
    child: FutureBuilder(
      future: hallSummary,
      builder: (context, snapshot) {
        // Display the [hallSummary] data.
        if (snapshot.hasData) {
          // Display ['Hall Closed'] if there is no data in [hallSummary].
          if (snapshot.data![0].foodItems.isEmpty) {
            return Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: Text('Hall Closed', style: constants.ContainerTextStyle),
            );

            // Display the food categories and food items.
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(
                  top: 8, bottom: constants.containerPaddingTitle),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 30, 30),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      // Display the food category.
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
                        child: Text(
                          category.category,
                          style: constants.ContainerTextStyle.copyWith(
                            fontSize: constants.titleFontSize - 2,
                          ),
                        ),
                      ),

                      // Display the food items.
                      Column(
                        children: category.foodItems.map((foodItem) {
                          return Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.topLeft,
                            child: Text(
                              foodItem,
                              style: constants.ContainerTextStyle.copyWith(
                                  fontSize: constants.bodyFontSize - 2,
                                  height: constants.bodyFontheight,
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              },
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
        return const Center(child: CircularProgressIndicator());
      },
    ),
  );
}

class FoodCategory {
  String category;
  List<String> foodItems;

  FoodCategory(this.category, this.foodItems);
}

Future<List<FoodCategory>> fetchSummary(String college, String mealTime) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final path = 'Summary/$college/$mealTime';
  final snapshot = await ref.child(path).get();

  if (snapshot.exists) {
    final data = snapshot.value as List<dynamic>;
    List<String> foodItems = data.map((item) => item.toString()).toList();
    return [FoodCategory("", foodItems)];
  } else {
    return [FoodCategory("Hall Closed", [])];
  }
}

Future<List<FoodCategory>> fetchAlbum(String college, String mealTime,
    {String cat = "", String day = "Today"}) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final path = '$day/$college/$mealTime/$cat';
  final snapshot = await ref.child(path).get();
  if (snapshot.exists) {
    if (cat.isEmpty) {
      // Fetch all items if cat is empty
      final data = snapshot.value as Map<dynamic, dynamic>;
      if (data.isEmpty) {
        // Handle the case when data is empty
        return [FoodCategory("No Food Items", [])];
      }

      // Extract and structure the data
      List<FoodCategory> foodList = [];
      data.forEach((key, value) {
        if (!value.toString().contains('update')) {
          // README: this code will ignore all instances where the values contain 'update'... please see TODO in menu_scraper_runner_copy.py for more information
          String cleanedKey = key.toString().replaceAll('*', '').trim();

          if (value is List) {
            List<String> foodItems =
                value.map((item) => item.toString()).toList();
            foodList.add(FoodCategory(cleanedKey, foodItems));
          }
        }
      });

      return foodList;
    } else {
      // Fetch specific category items
      final data = snapshot.value as List<dynamic>;
      // Extract and structure the data for the specific category
      List<String> foodItems = data.map((item) => item.toString()).toList();
      return [FoodCategory(cat, foodItems)];
    }
  } else {
    // Handle case when data is not found
    return [FoodCategory("Hall Closed", [])];
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        useMaterial3: true,
        colorScheme: constants.darkThemeColors(context),
        buttonTheme: const ButtonThemeData(
          colorScheme: ColorScheme.dark(),
        ),
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
  int animationms = 150;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MenuPage(name: "Merrill", hasLateNight: false),
    const MenuPage(name: "Cowell", hasLateNight: true),
    const MenuPage(name: "Nine", hasLateNight: true),
    const MenuPage(name: "Porter", hasLateNight: true),
    const MenuPage(name: "Oakes", hasLateNight: true),
    const Calculator(),
    const SettingsPage(),
    const AboutPage(),
  ];

  // Changes page based on icon selected [index].
  onItemTapped(int index, int ani) {
    setState(() {
      selectedIndex = index;
      animationms = ani;
    });
    //return 1;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      scakey.currentState?.onItemTapped(1, 0);
      await Future.delayed(const Duration(milliseconds: 10));
      scakey.currentState?.onItemTapped(0, 0);
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (selectedIndex != 0) {
      scakey.currentState?.onItemTapped(0, constants.aniLength);
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  double rh = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: animationms),
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

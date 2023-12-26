// MAIN program.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/utilities/router.dart';
import 'package:menu_app/views/root_page.dart';
import 'utilities/constants.dart' as constants;
import 'package:flutter/services.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utilities/firebase_options.dart';

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
            return Container(
              padding:
                  const EdgeInsets.only(top: constants.containerPaddingbody),
              alignment: Alignment.topCenter,
              child: Text(
                "Could not connect... Please retry.",
                textAlign: TextAlign.center,
                style: constants.ContainerTextStyle.copyWith(
                  fontFamily: constants.bodyFont,
                  fontSize: constants.bodyFontSize,
                  height: constants.bodyFontheight,
                ),
              ),
            );
          }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    ),
  );
}

// Get the adBool and call [adLoader].
Future<bool> getAdBool() async {
  final prefs = await SharedPreferences.getInstance();
  bool? adBool = prefs.getBool('showAd');

  if (adBool == null || adBool == true) {
    adLoader();
  }
  return adBool ?? true;
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
  bool adBool = await getAdBool();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //AppLovinMAX.showMediationDebugger();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp(
        adBool: adBool,
      )));
}

final scakey = GlobalKey<RootPageState>();

class MyApp extends StatelessWidget {
  final bool adBool;
  const MyApp({required this.adBool, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: goRouter,
    );
  }
}
// MAIN program.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/models/version.dart';
import 'package:menu_app/utilities/router.dart';
import 'utilities/constants.dart' as constants;
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utilities/firebase_options.dart';

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
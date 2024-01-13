// MAIN program.

import 'package:flutter/material.dart';
import 'package:menu_app/custom_widgets/ad_bar.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/utilities/router.dart';
import 'utilities/constants.dart' as constants;
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'utilities/firebase_options.dart';
import 'package:menu_app/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// MAIN function sets preferences.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getAdBool();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);


  //AppLovinMAX.showMediationDebugger();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Column(
        children: [
          Expanded(
            child: MaterialApp.router(
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
            ),
          ),
          const AdBar(),
        ],
      ),
    );
  }
}

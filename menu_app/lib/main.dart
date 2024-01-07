// MAIN program.

import 'package:flutter/material.dart';
import 'package:menu_app/custom_widgets/controllers/ad_bar_controller.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/utilities/router.dart';
import 'package:provider/provider.dart';
import 'utilities/constants.dart' as constants;
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utilities/firebase_options.dart';

// MAIN function sets preferences.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdBarController>(create: (_) => AdBarController()),
        // Add more providers as needed
      ],
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
    );
  }
}

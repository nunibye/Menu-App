import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/cowell_menu.dart';
import 'package:menu_app/merrill_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

class _RootPageState extends State<RootPage> {
  late Future futureAlbum;
  @override
  @override
  Widget build(BuildContext context) {
    double iconSizeCollege = MediaQuery.of(context).size.height / 6;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: const Color(constants.darkBlue),
          title: const Text(
            "UCSC Menu",
            style: TextStyle(
                fontSize: 45,
                fontFamily: 'Monoton',
                color: Color(constants.yellowGold)),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 20, left: 12),
              child: const Text(
                "DINING HALLS",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lato',
                    color: Color(constants.yellowGold)),
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
                          return const CowellMenu();
                        }),
                      );
                    },
                    icon: Image.asset('images/cowell.png'),
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
                    icon: Image.asset('images/porter.png'),
                    iconSize: iconSizeCollege,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const MerrillMenu();
                        }),
                      );
                    },
                    icon: Image.asset('images/crown.png'),
                    iconSize: iconSizeCollege,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const MerrillMenu();
                        }),
                      );
                    },
                    icon: Image.asset('images/nine.png'),
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
                    icon: Image.asset('images/carson.png'),
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
                    icon: Image.asset('images/all.png'),
                    iconSize: iconSizeCollege,
                  ),
                ],
              ),
            ),
            Container()
          ],
        )

        //Scaffold(
        //   appBar: AppBar(
        //     title: const Text('Fetch Data Example'),
        //   ),
        //   body: Center(
        //     child: FutureBuilder<Album>(
        //       future: futureAlbum,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           return Text(snapshot.data!.title);
        //         } else if (snapshot.hasError) {
        //           return Text('${snapshot.error}');
        //         }

        //         // By default, show a loading spinner.
        //         return const CircularProgressIndicator();
        //       },
        //     ),
        //   ),
        // ),
        );
  }
}

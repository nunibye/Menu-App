import 'dart:async';

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/cowell_menu.dart';
import 'package:menu_app/merrill_menu.dart';
import 'package:menu_app/nine_menu.dart';
import 'package:menu_app/porter_menu.dart';
import 'package:http/http.dart' as http;

Future fetchAlbum(college, meal) async {
  final response = await http.get(Uri.parse(
      'https://ucsc-menu-app-default-rtdb.firebaseio.com/$college/$meal.json'));

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

void main() => runApp(const MyApp());
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

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
  @override
  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum('Breakfast');
  // }

  @override
  Widget build(BuildContext context) {
    double iconSizeCollege = MediaQuery.of(context).size.height / 6;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: const Color(constants.darkBlue),
          title: const FittedBox(fit: BoxFit.fitWidth, child: Text(
            "UC Santa Cruz",
            style: TextStyle(
                fontSize: 40,
                fontFamily: 'Monoton',
                color: Color(constants.yellowGold)),
          ),),
          shape:
              const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        ),
        body: Column(
          children: <Widget>[
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
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (BuildContext context) {
                  //         return const CowellMenu();
                  //       }),
                  //     );
                  //   },
                  //   icon: Image.asset('images/carson2.png'),
                  //   iconSize: iconSizeCollege,
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (BuildContext context) {
                  //         return const CowellMenu();
                  //       }),
                  //     );
                  //   },
                  //   icon: Image.asset('images/all2.png'),
                  //   iconSize: iconSizeCollege,
                  // ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,height: MediaQuery.of(context).size.height / 4, child: const Text(
              "More Coming Soon Here",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Montserat',
                  fontWeight: FontWeight.bold,
                  color: Color(constants.white)),
            ),)
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
          ],
        ));
  }
}

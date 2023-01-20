import 'package:flutter/material.dart';
import 'package:menu_app/cowell_menu.dart';
import 'constants.dart' as constants;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double iconSizeCollege = MediaQuery.of(context).size.height/6;
    return Scaffold( 
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(builder: (BuildContext context) {
        //         return const CowellMenu();
        //       }),
        //     );
        //   },
        //   child: const Text("Cowell"),
        // ),

        body: Column(children:[const Text(
          "Dining halls",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 25, color: Color(constants.yellowGold)),
        ), Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height / 4,
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
                  return const CowellMenu();
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
                  return const CowellMenu();
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
    )])

        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Column(
        //       children: [
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (BuildContext context) {
        //                 return const CowellMenu();
        //               }),
        //             );
        //           },
        //           icon: Image.asset('images/cowell.png'),
        //           iconSize: iconSizeCollege,
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (BuildContext context) {
        //                 return const CowellMenu();
        //               }),
        //             );
        //           },
        //           icon: Image.asset('images/porter.png'),
        //           iconSize: iconSizeCollege,
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (BuildContext context) {
        //                 return const CowellMenu();
        //               }),
        //             );
        //           },
        //           icon: Image.asset('images/crown.png'),
        //           iconSize: iconSizeCollege,
        //         ),
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (BuildContext context) {
        //                 return const CowellMenu();
        //               }),
        //             );
        //           },
        //           icon: Image.asset('images/nine.png'),
        //           iconSize: iconSizeCollege,
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (BuildContext context) {
        //                 return const CowellMenu();
        //               }),
        //             );
        //           },
        //           icon: Image.asset('images/carson.png'),
        //           iconSize: iconSizeCollege,
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (BuildContext context) {
        //                 return const CowellMenu();
        //               }),
        //             );
        //           },
        //           icon: Image.asset('images/all.png'),
        //           iconSize: iconSizeCollege,
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        );
  }
}

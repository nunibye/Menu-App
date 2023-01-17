import 'package:flutter/material.dart';
import 'package:menu_app/cowell_menu.dart';
// import 'package:flutter/widgets.dart';

// class SizeConfig {
//   static MediaQueryData _mediaQueryData;
//   static double screenWidth;
//   static double screenHeight;
//   static double blockSizeHorizontal;
//   static double blockSizeVertical;
//   static double _safeAreaHorizontal;
//   static double _safeAreaVertical;
//   static double safeBlockHorizontal;
//   static double safeBlockVertical;

//   void init(BuildContext context){
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     blockSizeHorizontal = screenWidth/100;
//     blockSizeVertical = screenHeight/100;
//     _safeAreaHorizontal = _mediaQueryData.padding.left +
//         _mediaQueryData.padding.right;
//     _safeAreaVertical = _mediaQueryData.padding.top +
//         _mediaQueryData.padding.bottom;
//     safeBlockHorizontal = (screenWidth - _safeAreaHorizontal)/100;
//     safeBlockVertical = (screenHeight - _safeAreaVertical)/100;
//   }
// }

class HomePage extends StatelessWidget {
  static const double hallSize = 150.0;
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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

        body: Row(
      children: [
        Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const CowellMenu();
                  }),
                );
              },
              icon: Image.asset('images/cowell_dining_hall.jpg'),
              iconSize: hallSize,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const CowellMenu();
                  }),
                );
              },
              icon: Image.asset('images/cowell_dining_hall.jpg'),
              iconSize: hallSize,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const CowellMenu();
                  }),
                );
              },
              icon: Image.asset('images/cowell_dining_hall.jpg'),
              iconSize: hallSize,
            ),
          ],
        ),
        Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const CowellMenu();
                  }),
                );
              },
              icon: Image.asset('images/cowell_dining_hall.jpg'),
              iconSize: hallSize,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const CowellMenu();
                  }),
                );
              },
              icon: Image.asset('images/cowell_dining_hall.jpg'),
              iconSize: hallSize,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const CowellMenu();
                  }),
                );
              },
              icon: Image.asset('images/cowell_dining_hall.jpg'),
              iconSize: hallSize,
            ),
          ],
        ),
      ],
    ));
  }
}

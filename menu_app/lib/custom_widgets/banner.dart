// import 'package:flutter/widgets.dart';
// import 'package:marquee/marquee.dart';
// import 'package:menu_app/models/menus.dart';
// // FIXME to controller
// Widget buildBanner() {
//   return (FutureBuilder(
//       future: fetchBanner(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data != 'null') {
//             final bannerText = snapshot.data;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 15),
//               child: Container(
//                 height: 30,
//                 color: const Color.fromARGB(100, 0, 60, 108),
//                 child: Marquee(
//                   text: bannerText!,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                   scrollAxis: Axis.horizontal,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   blankSpace: 20,
//                   velocity: 30,
//                   showFadingOnlyWhenScrolling: true,
//                   fadingEdgeStartFraction: 0.1,
//                   fadingEdgeEndFraction: 0.1,
//                   startPadding: 10,
//                 ),
//               ),
//             );
//           } else {
//             return const SizedBox(
//               height: 20,
//             );
//           }
//         } else {
//           return const SizedBox(
//             height: 20,
//           );
//         }
//       }));
// }

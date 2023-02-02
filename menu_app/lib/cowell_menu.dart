import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;

class CowellMenu extends StatefulWidget {
  const CowellMenu({super.key});

  @override
  State<CowellMenu> createState() => _CowellMenuState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _CowellMenuState extends State<CowellMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future futureAlbum;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    futureAlbum = main_page.fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cowell",
          style: TextStyle(
              fontSize: constants.menuHeadingSize,
              fontFamily: 'Monoton',
              color: Color(constants.yellowGold)),
        ),
        toolbarHeight: 60,
        centerTitle: false,
        backgroundColor: const Color(constants.darkBlue),
        shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.orange, size: constants.backArrowSize),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 6, color: Colors.orange),
            ),
          ),
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.egg_alt_outlined),
            ),
            Tab(
              icon: Icon(Icons.fastfood_outlined),
            ),
            Tab(
              icon: Icon(Icons.dinner_dining_outlined),
            ),
            Tab(
              icon: Icon(Icons.access_time),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            //padding: const EdgeInsets.only(top: 20, left: 12),
            child: FutureBuilder(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    padding: const EdgeInsets.all(4),
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        if (i % 2 == 0)
                          (Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2, color: Colors.white))),
                              padding: const EdgeInsets.all(12),
                              alignment: Alignment.topLeft,
                              child: Text(
                                snapshot.data[i],
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              )))
                        else
                          (Container(
                              padding: const EdgeInsets.all(4),
                              alignment: Alignment.topRight,
                              child: Text(
                                snapshot.data[i],
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              )))

                      // Text(
                      //   snapshot.data[i],
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Color(constants.yellowGold),
                      //   ),
                      // )
                    ],
                  );

                  // Text(
                  //   snapshot.data[1],
                  //   style: const TextStyle(
                  //       fontSize: 25, color: Color(constants.yellowGold)),
                  // );
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
                return const CircularProgressIndicator();
              },
            ),
          ),
          const Center(
            child: Text("It's rainy here"),
          ),
          const Center(
            child: Text("It's rainy here"),
          ),
          const Center(
            child: Text("It's sunny here"),
          ),
        ],
      ),
    );
  }
}







// class CowellMenu extends StatefulWidget {
//   const CowellMenu({super.key});

//   @override
//   State<CowellMenu> createState() => _CowellMenuState();
// }

// class _CowellMenuState extends State<CowellMenu> {
//   with TickerProviderStateMixin {
//   late TabController _tabController;
//   late Future futureAlbum;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     futureAlbum = main_page.fetchAlbum();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Cowell",
//           style: TextStyle(
//               fontSize: constants.menuHeadingSize,
//               fontFamily: 'Monoton',
//               color: Color(constants.yellowGold)),
//         ),
//         toolbarHeight: 80,
//         centerTitle: false,
//         backgroundColor: const Color(constants.darkBlue),
//         shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.orange,
//             size:constants.backArrowSize
//           ),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const <Widget>[
//             Tab(
//               icon: Icon(Icons.cloud_outlined),
//             ),
//             Tab(
//               icon: Icon(Icons.beach_access_sharp),
//             ),
//             Tab(
//               icon: Icon(Icons.brightness_5_sharp),
//             ),
//           ],
//         ),
//       ),
      
//       body:Container(
//               alignment: Alignment.topLeft,
//               padding: const EdgeInsets.only(top: 20, left: 12),
//               child: FutureBuilder(
//                 future: futureAlbum,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return Text(
//                       snapshot.data.toString(),
//                       style: const TextStyle(
//                           fontSize: 25, color: Color(constants.yellowGold)),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Text(
//                       '${snapshot.error}',
//                       style: const TextStyle(
//                           fontSize: 25, color: Color(constants.yellowGold)),
//                     );
//                   }

//                   // By default, show a loading spinner.
//                   return const CircularProgressIndicator();
//                 },
//               ),
//             )
//     );
//   }
// }
// }
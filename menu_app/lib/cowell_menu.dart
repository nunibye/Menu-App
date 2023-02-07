import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;
//import 'package:menu_app/nine_menu.dart';

class CowellMenu extends StatefulWidget {
  const CowellMenu({super.key});

  @override
  State<CowellMenu> createState() => _CowellMenuState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _CowellMenuState extends State<CowellMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future futureBreakfast;
  late Future futureLunch;
  late Future futureDinner;
  late Future futureLateNight;
  final time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    futureBreakfast = main_page.fetchAlbum('Cowell', 'Breakfast');
    futureLunch = main_page.fetchAlbum('Cowell', 'Lunch');
    futureDinner = main_page.fetchAlbum('Cowell', 'Dinner');
    futureLateNight = main_page.fetchAlbum('Cowell', 'Late%20Night');
    if (time.hour < 10) {
      _tabController.animateTo(0);
    } else if (time.hour < 16) {
      _tabController.animateTo(1);
    } else if (time.hour < 20) {
      _tabController.animateTo(2);
    } else {
      _tabController.animateTo(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _timeModalBottom(context);
        },
        backgroundColor: const Color.fromARGB(255, 94, 94, 94),
        child: const Icon(Icons.access_time_outlined),
      ),
      appBar: AppBar(
        title: const Text(
          "Cowell",
          style: TextStyle(
              fontWeight: FontWeight.normal,
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
          indicatorColor: Colors.orange,
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
              icon: Icon(Icons.bedtime_outlined),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          main_page.buildMeal(futureBreakfast),
          main_page.buildMeal(futureLunch),
          main_page.buildMeal(futureDinner),
          main_page.buildMeal(futureLateNight),
        ],
      ),
    );
  }

  // void _timeModalBottom(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(50), topRight: Radius.circular(50)),
  //       ),
  //       builder: (BuildContext bc) {
  //         return const SizedBox(

  //           height: 800,
  //           child: Text(
  //             "Hours",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontFamily: constants.bodyFont,
  //               fontWeight: FontWeight.w900,
  //               fontSize: constants.titleFontSize,
  //               color: Colors.black,
  //               height: constants.bodyFontheight,
  //             ),
  //           ),

  //       );
  //       });
  // }

  void _timeModalBottom(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        context: context,
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) => SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    children: const [Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Monday-Thursday",
                            style: TextStyle(
                              fontFamily: constants.bodyFont,
                              fontWeight: FontWeight.bold,
                              fontSize: constants.titleFontSize - 5,
                              color: Colors.black,
                              height: constants.bodyFontheight,
                            ))),
                      Text(
                        "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM",
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Friday",
                            style: TextStyle(
                              fontFamily: constants.bodyFont,
                              fontWeight: FontWeight.bold,
                              fontSize: constants.titleFontSize - 5,
                              color: Colors.black,
                              height: constants.bodyFontheight,
                            )),
                      ),
                      Text(
                          "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM"),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Saturday",
                            style: TextStyle(
                              fontFamily: constants.bodyFont,
                              fontWeight: FontWeight.bold,
                              fontSize: constants.titleFontSize - 5,
                              color: Colors.black,
                              height: constants.bodyFontheight,
                            )),
                      ),
                      Text(
                        "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
                      textAlign: TextAlign.left,),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Sunday",
                            style: TextStyle(
                              fontFamily: constants.bodyFont,
                              fontWeight: FontWeight.bold,
                              fontSize: constants.titleFontSize - 5,
                              color: Colors.black,
                              height: constants.bodyFontheight,
                            )),
                      ),
                      Text(
                        "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM",
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

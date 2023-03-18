// Displays Merrill college's menu.

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;

class MerrillMenu extends StatefulWidget {
  const MerrillMenu({super.key});

  @override
  State<MerrillMenu> createState() => _MerrillMenuState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MerrillMenuState extends State<MerrillMenu>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future futureBreakfast;
  late Future futureLunch;
  late Future futureDinner;
  final time = DateTime.now();
  final List<String> _dropdownValues = ["Today", "Tomorrow", "Day After"];
  String? _currentlySelected;

  @override
  void initState() {
    super.initState();

    // Call [fetchAlbum] to return list of meals during each food category.
    _tabController = TabController(length: 3, vsync: this);
    futureBreakfast = main_page.fetchAlbum('Merrill', 'Breakfast');
    futureLunch = main_page.fetchAlbum('Merrill', 'Lunch');
    futureDinner = main_page.fetchAlbum('Merrill', 'Dinner');

    // Change default displayed tab [_tabController] based on time of day.
    if (time.hour < 10) {
      _tabController.animateTo(0);
    } else if (time.hour < 16) {
      _tabController.animateTo(1);
    } else {
      _tabController.animateTo(2);
    }
  }

  // Build categorized page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hours info tab.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _timeModalBottom(context);
        },
        backgroundColor: const Color.fromARGB(255, 94, 94, 94),
        child: const Icon(Icons.access_time_outlined),
      ),

      // App heading.
      appBar: AppBar(
        title: const Text(
          "Merrill",
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
            main_page.scakey.currentState?.onItemTapped(0);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.orange, size: constants.backArrowSize),
        ),

        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _currentlySelected,
                onChanged: (newValue) {
                  setState(() {
                    _currentlySelected = newValue as String;
                  });
                },
                items: _dropdownValues.map((date) {
                  return DropdownMenuItem(
                    value: date,
                    child: Text(
                      date,
                      style: const TextStyle(color: Color(constants.bodyColor)),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],

        // actions: [
        //   DropdownButtonHideUnderline(
        //       child: DropdownButton(
        //     hint: const Icon(Icons.calendar_month),
        //     items:
        //         <String>['Today', 'Tomorrow', 'Day After'].map((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Text(value),
        //       );
        //     }).toList(),
        //     onChanged: (_) {},
        //   ))

        //   IconButton(
        //     onPressed: () {
        //       main_page.scakey.currentState?.onItemTapped(0);
        //     },
        //     icon: const Icon(Icons.calendar_month,
        //         color: Colors.orange, size: constants.backArrowSize),
        //         padding: EdgeInsets.only(right: 20),
        //   ),
        // ],

        // Categorized menu time [TabBar].
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
          ],
        ),
      ),

      // Children to the [_tabController].
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          main_page.buildMeal(futureBreakfast),
          main_page.buildMeal(futureLunch),
          main_page.buildMeal(futureDinner),
        ],
      ),
    );
  }

  // Displays Hall default weekly hours.
  // FIXME: Should pull from database which pulls from website.
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
                child: const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Monday-Friday",
                              style: TextStyle(
                                fontFamily: constants.bodyFont,
                                fontWeight: FontWeight.bold,
                                fontSize: constants.titleFontSize - 5,
                                color: Colors.black,
                                height: constants.bodyFontheight,
                              ))),
                      SizedBox(
                        width: constants.sizedBox,
                        child: Text(
                          "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

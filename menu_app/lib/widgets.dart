// Page to load the Side Navagation Bar.

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});
  @override

  // Build navagation page.
  Widget build(BuildContext context) {
    // Get 2/3 of the screen size.
    double screenWidth = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
        width: screenWidth,
        child: Drawer(
          backgroundColor: const Color(constants.backgroundColor),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Padding.
              const SizedBox(
                height: 30,
              ),

              // Display Slug Menu image.
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: constants.borderWidth,
                            color: Color(constants.darkGray)))),
                height: (screenWidth * 0.75) * 0.8,
                child: Image(
                  image: const AssetImage('images/menu_header.png'),
                  width: screenWidth - 50,
                ),
              ),

              // Link to Homepage.
              ListTile(
                leading: const Icon(
                  Icons.house,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState
                      ?.onItemTapped(0, constants.aniLength)
                },
              ),

              // Link to Calculator.
              ListTile(
                leading: const Icon(
                  Icons.calculate,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Calculator',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState
                      ?.onItemTapped(6, constants.aniLength)
                },
              ),

              // Link to Settings Page
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState
                      ?.onItemTapped(7, constants.aniLength)
                },
              ),

              // Link to About Us page.
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'About Us',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState
                      ?.onItemTapped(8, constants.aniLength)
                },
              ),
            ],
          ),
        ));
  }
}

class MenuPage extends StatefulWidget {
  final bool hasLateNight;
  final String name;
  const MenuPage({required this.name, required this.hasLateNight, super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future futureBreakfast;
  late Future futureLunch;
  late Future futureDinner;
  late Future futureLateNight;

  final time = DateTime.now();

  final List<String> _dropdownValues = ["Today", "Tomorrow", "Day After"];
  String _currentlySelected = "Today";

  @override
  void initState() {
    super.initState();

    // Call [fetchAlbum] to return list of meals during each food category.
    _tabController =
        TabController(length: widget.hasLateNight ? 4 : 3, vsync: this);
    futureBreakfast = main_page.fetchAlbum(widget.name, 'Breakfast');
    futureLunch = main_page.fetchAlbum(widget.name, 'Lunch');
    futureDinner = main_page.fetchAlbum(widget.name, 'Dinner');
    if (widget.hasLateNight) {
      futureLateNight = main_page.fetchAlbum(widget.name, 'Late%20Night');
    }

    // Change default displayed tab [_tabController] based on time of day.
    if (time.hour < 10) {
      _tabController.animateTo(0);
    } else if (time.hour < 16) {
      _tabController.animateTo(1);
    } else if (time.hour < 20) {
      _tabController.animateTo(2);
    } else {
      _tabController.animateTo(widget.hasLateNight ? 3 : 2);
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
        title: Text(
          widget.name,
          style: const TextStyle(
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
            main_page.scakey.currentState?.onItemTapped(0, constants.aniLength);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.orange, size: constants.backArrowSize),
        ),

        // Choose later date
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _currentlySelected,
                // alignment: AlignmentDirectional.bottomCenter,
                onChanged: (newValue) {
                  setState(() {
                    // Reset the page
                    _currentlySelected = newValue as String;

                    if (_currentlySelected == "Tomorrow") {
                      // print(_currentlySelected);
                      futureBreakfast = main_page.fetchAlbum(
                          widget.name, 'Breakfast',
                          day: "Tomorrow");
                      futureLunch = main_page.fetchAlbum(widget.name, 'Lunch',
                          day: "Tomorrow");
                      futureDinner = main_page.fetchAlbum(widget.name, 'Dinner',
                          day: "Tomorrow");
                      futureLateNight = main_page.fetchAlbum(
                          widget.name, 'Late%20Night',
                          day: "Tomorrow");
                    } else if (_currentlySelected == "Day After") {
                      // print(_currentlySelected);
                      futureBreakfast = main_page.fetchAlbum(
                          widget.name, 'Breakfast',
                          day: "Day%20after%20tommorw");
                      futureLunch = main_page.fetchAlbum(widget.name, 'Lunch',
                          day: "Day%20after%20tommorw");
                      futureDinner = main_page.fetchAlbum(widget.name, 'Dinner',
                          day: "Day%20after%20tommorw");
                      futureLateNight = main_page.fetchAlbum(
                          widget.name, 'Late%20Night',
                          day: "Day%20after%20tommorw");
                    } else {
                      // print(_currentlySelected);
                      futureBreakfast =
                          main_page.fetchAlbum(widget.name, 'Breakfast');
                      futureLunch = main_page.fetchAlbum(widget.name, 'Lunch');
                      futureDinner =
                          main_page.fetchAlbum(widget.name, 'Dinner');
                      futureLateNight =
                          main_page.fetchAlbum(widget.name, 'Late%20Night');
                    }
                    main_page.buildMeal(futureBreakfast);
                    main_page.buildMeal(futureLunch);
                    main_page.buildMeal(futureDinner);
                    main_page.buildMeal(futureLateNight);
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return _dropdownValues.map<Widget>((String item) {
                    // This is the widget that will be shown when you select an item.
                    // Here custom text style, alignment and layout size can be applied
                    // to selected item string.
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        item,
                        style: const TextStyle(
                            color: Color(constants.bodyColor),
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList();
                },
                items: _dropdownValues.map((date) {
                  return DropdownMenuItem(
                    value: date,
                    child: Text(
                      date,
                      style: const TextStyle(color: Color(constants.darkGray)),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],

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
          tabs: <Widget>[
            const Tab(
              icon: Icon(Icons.egg_alt_outlined),
            ),
            const Tab(
              icon: Icon(Icons.fastfood_outlined),
            ),
            const Tab(
              icon: Icon(Icons.dinner_dining_outlined),
            ),
            if (widget.hasLateNight)
              const Tab(
                icon: Icon(Icons.bedtime_outlined),
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
          if (widget.hasLateNight) main_page.buildMeal(futureLateNight),
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
                  child: Column(
                    children: [
                      if (widget.name == 'Nine')
                        const _NineModal()
                      else if (widget.name == 'Oakes')
                        const _OakesModal()
                      else if (widget.name == 'Cowell')
                        const _CowellModal()
                      else if (widget.name == 'Porter')
                        const _PorterModal()
                      else 
                        const _MerrillModal()
                    ],
                  )),
            ));
  }
}

class _OakesModal extends StatelessWidget {
  const _OakesModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Column(
        children: const [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text("Monday-Thursday",
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
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM",
            ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
            ),
          ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
              textAlign: TextAlign.left,
            ),
          ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM\n\n*Does not reflect special hours.",
            ),
          ),
        ],
      ),
    );
  }
}

class _CowellModal extends StatelessWidget {
  const _CowellModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Column(
        children: const [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text("Monday-Thursday",
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
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM",
            ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
                "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM"),
          ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
              textAlign: TextAlign.left,
            ),
          ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM\n\n*Does not reflect special hours.",
            ),
          ),
        ],
      ),
    );
  }
}

class _MerrillModal extends StatelessWidget {
  const _MerrillModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Column(
        children: const [
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
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\n\n*Does not reflect special hours.",
            ),
          ),
        ],
      ),
    );
  }
}

class _PorterModal extends StatelessWidget {
  const _PorterModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Column(
        children: const [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text("Monday-Thursday",
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
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM",
            ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
            ),
          ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM",
              textAlign: TextAlign.left,
            ),
          ),
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
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM\n\n*Does not reflect special hours.",
            ),
          ),
        ],
      ),
    );
  }
}

class _NineModal extends StatelessWidget {
  const _NineModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Column(
        children: const [
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
              "Breakfast: 7-11AM\nContinuous Dining: 11-11:30AM\nLunch: 11:30AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM",
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Saturday-Sunday",
                style: TextStyle(
                  fontFamily: constants.bodyFont,
                  fontWeight: FontWeight.bold,
                  fontSize: constants.titleFontSize - 5,
                  color: Colors.black,
                  height: constants.bodyFontheight,
                )),
          ),
          SizedBox(
            width: constants.sizedBox,
            child: Text(
              "Breakfast: 7-10AM\nBrunch: 10AM-2PM\nContinuous Dining: 2-5PM\nDinner: 5-8PM\nLate Night: 8-11PM\n\n*Does not reflect special hours.",
            ),
          ),
        ],
      ),
    );
  }
}

// Page to load the Side Navagation Bar.

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;
import 'package:firebase_database/firebase_database.dart';

class Hour {
  final String day;
  final String schedule;

  Hour(this.day, this.schedule);
}

Future<List<Hour>> fetchDataFromDatabase(String name) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  final snapshot = await ref.child('Hours/$name').get();
  if (snapshot.exists) {
    final data = snapshot.value as List<dynamic>;

    final hoursList = <Hour>[];

    for (int i = 0; i < data.length; i++) {
      final dayData = data[i];
      if (dayData != null && dayData is Map<dynamic, dynamic>) {
        final dayKey = dayData.keys.first.toString();
        final schedule =
            dayData.values.first.toString().replaceAll('\\n', '\n');
        hoursList.add(Hour(dayKey, schedule));
      }
    }

    return hoursList;
  } else {
    return [];
  }
}

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
          _timeModalBottom(context, widget.name);
        },
        shape: const CircleBorder(),
        enableFeedback: true,
        backgroundColor: const Color.fromARGB(255, 94, 94, 94),
        child: const Icon(
          Icons.access_time_outlined,
          color: Colors.white,
        ),
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
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  padding: const EdgeInsets.only(right: 10),
                  enableFeedback: true,
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: const Color.fromARGB(255, 37, 37, 37),
                  value: _currentlySelected,
                  alignment: Alignment.center,
                  onChanged: (newValue) {
                    setState(() {
                      // Reset the page
                      _currentlySelected = newValue as String;

                      if (_currentlySelected == "Tomorrow") {
                        futureBreakfast = main_page.fetchAlbum(
                            widget.name, 'Breakfast',
                            day: "Tomorrow");
                        futureLunch = main_page.fetchAlbum(widget.name, 'Lunch',
                            day: "Tomorrow");
                        futureDinner = main_page
                            .fetchAlbum(widget.name, 'Dinner', day: "Tomorrow");
                        futureLateNight = main_page.fetchAlbum(
                            widget.name, 'Late%20Night',
                            day: "Tomorrow");
                      } else if (_currentlySelected == "Day After") {
                        futureBreakfast = main_page.fetchAlbum(
                            widget.name, 'Breakfast',
                            day: "Day%20after%20tomorrow");
                        futureLunch = main_page.fetchAlbum(widget.name, 'Lunch',
                            day: "Day%20after%20tomorrow");
                        futureDinner = main_page.fetchAlbum(
                            widget.name, 'Dinner',
                            day: "Day%20after%20tomorrow");
                        futureLateNight = main_page.fetchAlbum(
                            widget.name, 'Late%20Night',
                            day: "Day%20after%20tomorrow");
                      } else {
                        futureBreakfast =
                            main_page.fetchAlbum(widget.name, 'Breakfast');
                        futureLunch =
                            main_page.fetchAlbum(widget.name, 'Lunch');
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
                      alignment: Alignment.centerLeft,
                      value: date,
                      child: Text(
                        date,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],

        // Categorized menu time [TabBar].
        bottom: TabBar(
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
  void _timeModalBottom(context, String name) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return FutureBuilder(
            future: fetchDataFromDatabase(
                name), // Replace with your data fetching function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CircularProgressIndicator(),
                ); // Display a loading indicator while data is fetched
              } else if (snapshot.hasError) {
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: constants.ModalTitleStyle,
                  ),
                  width: MediaQuery.of(context).size.width,
                );
              } else if (!snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    'No data available',
                    style: constants.ModalTitleStyle,
                  ),
                  width: MediaQuery.of(context).size.width,
                );
              } else if (snapshot.data!.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    'No data available',
                    style: constants.ModalTitleStyle,
                  ),
                  width: MediaQuery.of(context).size.width,
                );
              } else {
                // Replace the itemCount and data with your fetched data
                final List<Hour>? data = snapshot.data;
                return ListView.builder(
                  itemCount: data?.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    final hour = data?[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(top: 10),
                          title: Text(
                            hour?.day ?? 'No data',
                            textAlign: TextAlign.center,
                          ),
                          titleTextStyle: constants.ModalTitleStyle,
                          subtitle: Container(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 5,
                                top: 5),
                            child: Text(
                              hour?.schedule ?? 'No data',
                              style: constants.ModalSubtitleStyle,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return CircularProgressIndicator();
            },
          );
        },
      ),
    );
  }
}

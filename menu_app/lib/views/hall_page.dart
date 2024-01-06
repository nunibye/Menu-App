// Page to load the Side Navagation Bar.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/custom_widgets/menu.dart';
import '../utilities/constants.dart' as constants;

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
  late Future<List<FoodCategory>> futureBreakfast;
  late Future<List<FoodCategory>> futureLunch;
  late Future<List<FoodCategory>> futureDinner;
  late Future<List<FoodCategory>> futureLateNight;

  final time = DateTime.now();

  final List<String> _dropdownValues = ["Today", "Tomorrow", "Day After"];
  String _currentlySelected = "Today";

  @override
  void initState() {
    super.initState();

    // Call [fetchAlbum] to return list of meals during each food category.
    _tabController =
        TabController(length: widget.hasLateNight ? 4 : 3, vsync: this);
    futureBreakfast = fetchAlbum(widget.name, 'Breakfast');
    futureLunch = fetchAlbum(widget.name, 'Lunch');
    futureDinner = fetchAlbum(widget.name, 'Dinner');
    if (widget.hasLateNight) {
      futureLateNight = fetchAlbum(widget.name, 'Late Night');
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
            context.pop();
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
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: const Color.fromARGB(255, 37, 37, 37),
                  value: _currentlySelected,
                  alignment: Alignment.center,
                  onChanged: (newValue) {
                    setState(() {
                      // Reset the page
                      _currentlySelected = newValue as String;

                      if (_currentlySelected == "Tomorrow") {
                        futureBreakfast = fetchAlbum(widget.name, 'Breakfast',
                            day: "Tomorrow");
                        futureLunch =
                            fetchAlbum(widget.name, 'Lunch', day: "Tomorrow");
                        futureDinner =
                            fetchAlbum(widget.name, 'Dinner', day: "Tomorrow");
                        futureLateNight = fetchAlbum(widget.name, 'Late Night',
                            day: "Tomorrow");
                      } else if (_currentlySelected == "Day After") {
                        futureBreakfast = fetchAlbum(widget.name, 'Breakfast',
                            day: "Day after tomorrow");
                        futureLunch = fetchAlbum(widget.name, 'Lunch',
                            day: "Day after tomorrow");
                        futureDinner = fetchAlbum(widget.name, 'Dinner',
                            day: "Day after tomorrow");
                        futureLateNight = fetchAlbum(widget.name, 'Late Night',
                            day: "Day after tomorrow");
                      } else {
                        futureBreakfast = fetchAlbum(widget.name, 'Breakfast');
                        futureLunch = fetchAlbum(widget.name, 'Lunch');
                        futureDinner = fetchAlbum(widget.name, 'Dinner');
                        futureLateNight = fetchAlbum(widget.name, 'Late Night');
                      }
                      buildMeal(futureBreakfast);
                      buildMeal(futureLunch);
                      buildMeal(futureDinner);
                      buildMeal(futureLateNight);
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
          buildMeal(futureBreakfast),
          buildMeal(futureLunch),
          buildMeal(futureDinner),
          if (widget.hasLateNight) buildMeal(futureLateNight),
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
            future: fetchDataFromDatabase(name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                    ),
                    const CircularProgressIndicator(),
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                    ),
                    Text(
                      'Error fetching data',
                      style: constants.modalTitleStyle,
                    ),
                  ],
                );
              } else {
                // Replace the itemCount and data with your fetched data
                final List<Modal>? data = snapshot.data;
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
                          titleTextStyle: constants.modalTitleStyle,
                          subtitle: Container(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 5,
                                top: 5),
                            child: Text(
                              hour?.schedule ?? 'No data',
                              style: constants.modalSubtitleStyle,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

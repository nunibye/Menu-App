import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/custom_widgets/menu.dart';
import 'package:menu_app/models/menus.dart';

class HallController extends ChangeNotifier {
  late TabController tabController;
  late Future<List<FoodCategory>> futureBreakfast;
  late Future<List<FoodCategory>> futureLunch;
  late Future<List<FoodCategory>> futureDinner;
  late Future<List<FoodCategory>> futureLateNight;

  final bool hasLateNight;
  final String name;

  final time = DateTime.now();

  final List<String> dropdownValues = ["Today", "Tomorrow", "Day After"];
  String currentlySelected = "Today";

  HallController({
    required this.name,
    required this.hasLateNight,
    required TickerProvider vsync,
  }) {
    init(vsync);
  }

  void init(TickerProvider vsync) {
    // Call [fetchAlbum] to return list of meals during each food category.
    tabController = TabController(length: hasLateNight ? 4 : 3, vsync: vsync);
    futureBreakfast = fetchAlbum(name, 'Breakfast');
    futureLunch = fetchAlbum(name, 'Lunch');
    futureDinner = fetchAlbum(name, 'Dinner');
    if (hasLateNight) {
      futureLateNight = fetchAlbum(name, 'Late Night');
    }

    // Change default displayed tab [_tabController] based on time of day.
    if (time.hour < 10) {
      tabController.animateTo(0);
    } else if (time.hour < 16) {
      tabController.animateTo(1);
    } else if (time.hour < 20) {
      tabController.animateTo(2);
    } else {
      tabController.animateTo(hasLateNight ? 3 : 2);
    }
  }

  changeDay(String? newValue) {
    // Reset the page
    currentlySelected = newValue as String;

    if (currentlySelected == "Tomorrow") {
      futureBreakfast = fetchAlbum(name, 'Breakfast', day: "Tomorrow");
      futureLunch = fetchAlbum(name, 'Lunch', day: "Tomorrow");
      futureDinner = fetchAlbum(name, 'Dinner', day: "Tomorrow");
      futureLateNight = fetchAlbum(name, 'Late Night', day: "Tomorrow");
    } else if (currentlySelected == "Day After") {
      futureBreakfast =
          fetchAlbum(name, 'Breakfast', day: "Day after tomorrow");
      futureLunch = fetchAlbum(name, 'Lunch', day: "Day after tomorrow");
      futureDinner = fetchAlbum(name, 'Dinner', day: "Day after tomorrow");
      futureLateNight =
          fetchAlbum(name, 'Late Night', day: "Day after tomorrow");
    } else {
      futureBreakfast = fetchAlbum(name, 'Breakfast');
      futureLunch = fetchAlbum(name, 'Lunch');
      futureDinner = fetchAlbum(name, 'Dinner');
      futureLateNight = fetchAlbum(name, 'Late Night');
    }
    notifyListeners();
    buildMeal(futureBreakfast);
    buildMeal(futureLunch);
    buildMeal(futureDinner);
    buildMeal(futureLateNight);
    
  }
}

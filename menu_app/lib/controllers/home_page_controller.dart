// home_page_view_model.dart
import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/models/version.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageController extends ChangeNotifier {
  List<String> colleges = [];
  bool versionCheckResult = true;

  HomePageController() {
    init();
  }

  Future<void> init() async {
    getCollegeOrder();
  }

  Future<void> getCollegeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString('collegesString');

    if (text == null || text.split(',').length == 4) {
      colleges = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];
    } else {
      colleges = text.split(',');
    }

    // Perform version check
    versionCheckResult = await performVersionCheck();
    notifyListeners();
  }

  Future<List<FoodCategory>> fetchSummary(String college, String mealTime) {
    return fetchSummary(college, mealTime);
  }

  // Function to return the [index] of [college] to display correct page onTap.
  getIndex(college) {
    if (college == "Nine") {
      return 3;
    } else if (college == "Cowell") {
      return 2;
    } else if (college == "Porter") {
      return 4;
    } else if (college == "Oakes") {
      return 5;
    } else {
      return 1;
    }
  }

  // Function to reload data when refresh is triggered
  Future<void> refresh() async {
    await getCollegeOrder();
  }
}

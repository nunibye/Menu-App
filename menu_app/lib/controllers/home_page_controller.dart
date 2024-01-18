// home_page_view_model.dart
import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/models/version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menu_app/custom_widgets/update_dialog.dart';

class HomePageController extends ChangeNotifier {
  List<String> colleges = [];
  List<Widget> summaries = [];
  bool ad = false;
  bool versionCheckResult = true;
  final BuildContext context;
  String mealTime = '';
  DateTime time = DateTime.now();
  int index = 0;

  HomePageController({required this.context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await performVersionCheck()) {
        _showDialog();
      }
    });
    init();
  }

  void onTabPressed(int newIndex) {
    index = newIndex;
    switch (index) {
      case 0:
        mealTime = 'Breakfast';
        break;
      case 1:
        mealTime = 'Lunch';
        break;
      case 2:
        mealTime = 'Dinner';
        break;
      case 3:
        mealTime = 'Late Night';
        break;
      case 4:
        mealTime = 'Null';
        break;
    }

    notifyListeners();
  }

  void _showDialog() {
    showUpdateDialog(context);
  }

  Future<void> init() async {
    getCollegeOrder();
    loadMealTime();
  }

  void getCollegeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString('collegesString');

    if (text == null || text.split(',').length == 4) {
      colleges = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];
    } else {
      colleges = text.split(',');
    }
    notifyListeners();
  }

  void loadMealTime() {
    DateTime time = DateTime.now();
    if (time.hour <= 4 || time.hour >= 23) {
      mealTime = 'Null';
      index = 4; // will not highlight a button time
    } else if (time.hour < 11 && time.hour > 4) {
      mealTime = 'Breakfast';
      index = 0;
    } else if (time.hour < 16) {
      mealTime = 'Lunch';
      index = 1;
    } else if (time.hour < 20) {
      mealTime = 'Dinner';
      index = 2;
    } else if (time.hour < 23) {
      mealTime = 'Late Night';
      index = 3;
    }
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
    getCollegeOrder();
    time = DateTime.now();
    loadMealTime();
  }
}

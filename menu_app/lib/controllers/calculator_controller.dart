import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorController extends ChangeNotifier {

  CalculatorController() {
    loadValuesFromSharedPreferences();
  }

  // Create default variables.
  static const totalSlugPoints = 1000.0;
  static const mealDay = 3.0;
  static const mealCost = 12.23;

  // Create text controllers so user may edit.
  final totalSlugPointsController =
      TextEditingController(text: totalSlugPoints.toString());
  final mealDayController = TextEditingController(text: mealDay.toString());
  final mealCostController = TextEditingController(text: mealCost.toString());
  final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  // Function to load values from shared preferences.
  Future<void> loadValuesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    totalSlugPointsController.text =
        '${prefs.getDouble('totalSlugPoints') ?? 1000.0}';
    mealDayController.text = '${prefs.getDouble('mealDay') ?? 3.0}';
    mealCostController.text = '${prefs.getDouble('mealCost') ?? 12.23}';
    dateController.text = calculateDate();
    notifyListeners();
  }

  // Method to update totalSlugPoints
  void updateTotalSlugPoints() async {
    notifyListeners();
    double? val = double.tryParse(totalSlugPointsController.text);
    if (val != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('totalSlugPoints', val);
    }
  }

  // Method to update mealDay
  void updateMealDay() async {
    notifyListeners();
    double? val = double.tryParse(mealDayController.text);
    if (val != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('mealDay', val);
    }
  }

  // Method to update mealCost
  void updateMealCost() async {
    notifyListeners();
    double? val = double.tryParse(mealCostController.text);
    if (val != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('mealCost', val);
    }
  }

  // Method to update mealDate
  void updateMealDate(String newValue) async {
    dateController.text = newValue;
    notifyListeners();
  }

  // Display ad.
  changeAdVar(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showAd', value);
  }

  String calculateDate() {
    final DateTime winter = DateTime(DateTime.now().year, 3, 24);
    final DateTime spring = DateTime(DateTime.now().year, 6, 15);
    final DateTime summer = DateTime(DateTime.now().year, 9, 1);
    final DateTime fall = DateTime(DateTime.now().year, 12, 9);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    // Set default end date based on current date.
    if (winter.isAfter(now)) {
      return formatter.format(winter);
    } else if (spring.isAfter(now)) {
      return formatter.format(spring);
    } else if (summer.isAfter(now)) {
      return formatter.format(summer);
    } else if (fall.isAfter(now)) {
      return formatter.format(fall);
    } else {
      return formatter.format(now);
    }
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  num getDays() {
    return num.parse(
        (DateTime.parse(dateController.text).difference(DateTime.now()).inDays +
                1)
            .toString());
  }

  double getTotalSlugPoints() {
    return double.tryParse(totalSlugPointsController.text) ?? 0;
  }

  double getMealDay() {
    return double.tryParse(mealDayController.text) ?? 0;
  }

  double getMealCost() {
    return double.tryParse(mealCostController.text) ?? 0;
  }

  String getMealAmount() {
    return ((getTotalSlugPoints() -
                (getMealDay() * getMealCost() * getDays())) /
            getMealCost())
        .toStringAsFixed(2);
  }

  String getPointsAmount() {
    return ((getTotalSlugPoints() - (getMealDay() * getMealCost() * getDays())))
        .toStringAsFixed(2);
  }

  String getMealDayAmount() {
    return (((getTotalSlugPoints() / getMealCost()) / getDays()))
        .toStringAsFixed(2);
  }
}

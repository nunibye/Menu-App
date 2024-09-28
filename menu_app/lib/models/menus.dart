import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class FoodCategory {
  String category;
  List<String> foodItems;

  FoodCategory(this.category, this.foodItems);
}

Future<String> fetchBanner() async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('Banner').get();
  if (snapshot.exists && snapshot.value != '') {
    return snapshot.value as String;
  }

  return 'null';
}

Future<List<FoodCategory>> fetchSummary(String college, String mealTime) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final path = 'Summary/$college/$mealTime';
  final snapshot = await ref.child(path).get();

  if (snapshot.exists) {
    final data = snapshot.value as List<dynamic>;
    List<String> foodItems = data.map((item) => item.toString()).toList();
    return [FoodCategory("", foodItems)];
  } else {
    return [FoodCategory("Hall Closed", [])];
  }
}
// Future<List<FoodCategory>> fetchSummary(List<String> colleges) async {
//   final DatabaseReference ref = FirebaseDatabase.instance.ref();
//   final path = 'Summary';
//   final snapshot = await ref.child(path).get();

//   if (snapshot.exists) {
//     final data = snapshot.value as List<dynamic>;
//     List<String> foodItems = data.map((item) => item.toString()).toList();
//     return [FoodCategory("", foodItems)];
//   } else {
//     return [FoodCategory("Hall Closed", [])];
//   }
// }

Future<List<FoodCategory>> fetchSummaryList(
    List<String> colleges, String mealTime) async {
  List<Future<List<FoodCategory>>> futures = [];

  for (var college in colleges) {
    futures.add(fetchSummary(college, mealTime));
  }
  List<List<FoodCategory>> results = await Future.wait(futures);
  List<FoodCategory> combinedResults = [];
  for (var resultList in results) {
    combinedResults.addAll(resultList);
  }
  return combinedResults;
}

Future<List<FoodCategory>> fetchAlbum(String college, String mealTime,
    {String cat = "", String day = "Today"}) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final path = '$day/$college/$mealTime/$cat';
  final snapshot = await ref.child(path).get();
  if (snapshot.exists) {
    if (cat.isEmpty) {
      // Fetch all items if cat is empty
      final data = snapshot.value as Map<dynamic, dynamic>;
      if (data.isEmpty) {
        // Handle the case when data is empty
        return [FoodCategory("No Food Items", [])];
      }

      // Extract and structure the data
      List<FoodCategory> foodList = [];
      data.forEach((key, value) {
        if (!value.toString().contains('update')) {
          // README: this code will ignore all instances where the values contain 'update'... please see ToDo in menu_scraper_runner_copy.py for more information
          String cleanedKey = key.toString().replaceAll('*', '').trim();

          if (value is List) {
            List<String> foodItems =
                value.map((item) => item.toString()).toList();
            foodList.add(FoodCategory(cleanedKey, foodItems));
          }
        }
      });

      return foodList;
    } else {
      // Fetch specific category items
      final data = snapshot.value as List<dynamic>;
      // Extract and structure the data for the specific category
      List<String> foodItems = data.map((item) => item.toString()).toList();
      return [FoodCategory(cat, foodItems)];
    }
  } else {
    // Handle case when data is not found
    return [FoodCategory("Hall Closed", [])];
  }
}

class Modal {
  final String day;
  final String schedule;

  Modal(this.day, this.schedule);
}

Future<List<Modal>> fetchDataFromDatabase(String name) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  final snapshot = await ref.child('Hours/$name').get();
  if (snapshot.exists) {
    final data = snapshot.value as List<dynamic>;

    final hoursList = <Modal>[];

    for (int i = 0; i < data.length; i++) {
      final dayData = data[i];
      if (dayData != null && dayData is Map<dynamic, dynamic>) {
        final dayKey = dayData.keys.first.toString();
        final schedule =
            dayData.values.first.toString().replaceAll('\\n', '\n');
        hoursList.add(Modal(dayKey, schedule));
      }
    }

    return hoursList;
  } else {
    return [];
  }
}

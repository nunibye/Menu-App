import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/utilities/constants.dart' as c;

class NutritionalInfo {
  String servingSize;
  String totalFat;
  String saturatedFat;
  String transFat;
  String cholesterol;
  String sodium;
  String totalCarb;
  String dietaryFiber;
  String sugars;
  String protein;
  String ingredients;
  String allergens;
  String calories;
  List<String> tags;

  NutritionalInfo({
    required this.servingSize,
    required this.totalFat,
    required this.saturatedFat,
    required this.transFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarb,
    required this.dietaryFiber,
    required this.sugars,
    required this.protein,
    required this.ingredients,
    required this.allergens,
    required this.calories,
    required this.tags,
  });

  factory NutritionalInfo.fromJson(Map<dynamic, dynamic> json) {
    return NutritionalInfo(
      servingSize: json['ServingSize'] ?? "",
      totalFat: json['TotalFat'] ?? "",
      saturatedFat: json['SaturatedFat'] ?? "",
      transFat: json['TransFat'] ?? "",
      cholesterol: json['Cholesterol'] ?? "",
      sodium: json['Sodium'] ?? "",
      totalCarb: json['TotalCarb'] ?? "",
      dietaryFiber: json['DietaryFiber'] ?? "",
      sugars: json['Sugars'] ?? "",
      protein: json['Protein'] ?? "",
      ingredients: json['Ingredients'] ?? "",
      calories: json['Calories'] ?? "",
      allergens: json['Allergens'] ?? "",
      tags: (json['Tags'] as List<dynamic>?)
              ?.map((item) => item?.toString() ?? "")
              .toList() ??
          [""],
    );
  }
}

class FoodItem {
  final String name;
  final NutritionalInfo nutritionalInfo;

  FoodItem({
    required this.name,
    required this.nutritionalInfo,
  });

  factory FoodItem.fromJson(Map<dynamic, dynamic> json) {
    return FoodItem(
      name: json['Name'] as String,
      nutritionalInfo: NutritionalInfo.fromJson(json['NutritionalInfo']),
    );
  }
}

class FoodCategory {
  final String category;
  final List<FoodItem> foodItems;

  FoodCategory({
    required this.category,
    required this.foodItems,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    var foodItemsJson = json['FoodItems'] as List;
    List<FoodItem> foodItemsList =
        foodItemsJson.map((item) => FoodItem.fromJson(item)).toList();

    return FoodCategory(
      category: json['Category'] as String? ?? '',
      foodItems: foodItemsList,
    );
  }
}

class WaitzData {
  int busyness;
  String name;

  WaitzData({
    required this.busyness,
    required this.name,
  });

  // Factory method to create a DiningLocation from JSON
  factory WaitzData.fromJson(Map<String, dynamic> json) {
    return WaitzData(
      busyness: json['busyness'] as int,
      name: json['name'] as String,
    );
  }
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
  final path = 'menuv2/Summary/$college/$mealTime';
  final snapshot = await ref.child(path).get();

  if (snapshot.exists) {
    final data =
        snapshot.value as Map<dynamic, dynamic>; // Data is a list of maps

    List<FoodCategory> categories = [];
    List<FoodItem> foodItems = [];

    for (Map<dynamic, dynamic> foodItem in data["FoodItems"]) {
      foodItems.add(FoodItem.fromJson(foodItem));
    }
    categories.add(FoodCategory(
      category: data["Name"],
      foodItems: foodItems,
    ));

    return categories;
  } else {
    return [FoodCategory(category: "Hall Closed", foodItems: [])];
  }
}

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
  final path = 'menuv2/$day/$college/$mealTime/$cat';
  final snapshot = await ref.child(path).get();

  if (snapshot.exists) {
    if (cat.isEmpty) {
      // Fetch all items if cat is empty
      final data = snapshot.value as List<dynamic>;
      if (data.isEmpty) {
        return [FoodCategory(category: "No Food Items", foodItems: [])];
      }

      // Extract and structure the data
      List<FoodCategory> foodList = [];

      for (Map<dynamic, dynamic> cat in data) {
        List<FoodItem> foodItems = [];
        if (cat["FoodItems"] != null) {
          for (Map<dynamic, dynamic> foodItem in cat["FoodItems"]) {
            foodItems.add(FoodItem.fromJson(foodItem));
          }
          foodList.add(FoodCategory(
            category: cat["Name"],
            foodItems: foodItems,
          ));
        }
      }

      return foodList;
    } else {
      // Fetch specific category items
      final data = snapshot.value as List<dynamic>;
      // Extract and structure the data for the specific category
      List<FoodItem> foodItems = data
          .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
          .toList();
      return [FoodCategory(category: cat, foodItems: foodItems)];
    }
  } else {
    // Handle case when data is not found
    return [FoodCategory(category: "Hall Closed", foodItems: [])];
  }
}

class Hours {
  final String day;
  final String schedule;

  Hours(this.day, this.schedule);
}

Future<List<Hours>> fetchHoursFromDatabase(String name) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  final snapshot = await ref.child('Hours/$name').get();
  if (snapshot.exists) {
    final data = snapshot.value as List<dynamic>;

    final hoursList = <Hours>[];

    for (int i = 0; i < data.length; i++) {
      final dayData = data[i];
      if (dayData != null && dayData is Map<dynamic, dynamic>) {
        final dayKey = dayData.keys.first.toString();
        final schedule =
            dayData.values.first.toString().replaceAll('\\n', '\n');
        hoursList.add(Hours(dayKey, schedule));
      }
    }

    return hoursList;
  } else {
    return [];
  }
}

Future<Map<String, String>> fetchWaitzMap() async {
  Map<String, String> locations = {};

  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('waitzLocations').get();

  for (DataSnapshot entry in snapshot.children) {
    locations[entry.key.toString()] = entry.value.toString();
  }

  return locations;
}

class HoursEvent {
  final String name;
  final TimeOfDay time;

  HoursEvent({required this.name, required this.time});

  @override
  String toString() {
    return name;
  }
}

TimeOfDay _parseTimeString(String timeString) {
  // Split the string into time and AM/PM indicator
  String timePart = timeString.substring(0, timeString.length - 2);
  String period = timeString.substring(timeString.length - 2);

  // Split hours and minutes
  List<String> parts = timePart.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  // Adjust for PM
  if (period.toLowerCase() == "pm" && hour != 12) {
    hour += 12;
  }
  // Adjust for 12 AM
  if (period.toLowerCase() == "am" && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

List<HoursEvent> _getHoursList(Map<String, String> data) {
  final List<HoursEvent> list = [];
  data.forEach((key, value) {
    list.add(HoursEvent(name: key, time: _parseTimeString(value)));
  });
  list.sort((a, b) {
    if (a.time.hour != b.time.hour) {
      return a.time.hour.compareTo(b.time.hour);
    }
    return a.time.minute.compareTo(b.time.minute);
  });
  return list;
}

Future<Map<String, List<HoursEvent>>> fetchEventHours(String name) async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('newHours/$name').get();
  if (snapshot.exists) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final Map<String, List<HoursEvent>> map = {};
    for (final i in data.keys) {
      if (i.contains('-')) {
        final daySpan = i.split("-");
        final firstDay = c.daysOfWeek.indexOf(daySpan[0]);
        final lastDay = c.daysOfWeek.indexOf(daySpan[1]);
        int day = firstDay;
        while (day != lastDay + 1 || lastDay == 6 && day == 0) {
          map[c.daysOfWeek[day]] =
              _getHoursList(Map<String, String>.from(data[i] as Map));

          if (day == 6) {
            day = 0;
          } else {
            day++;
          }
        }
      } else {
        map[i] = _getHoursList(Map<String, String>.from(data[i] as Map));
      }
    }
    return map;
  }
  throw Error();
}

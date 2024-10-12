import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/utilities/constants.dart' as c;

class FoodCategory {
  String category;
  List<String> foodItems;

  FoodCategory(this.category, this.foodItems);
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

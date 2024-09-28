import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';

class TimeNotifier extends ChangeNotifier {
  final Map<String, List<Hours>> _hours = {};
  Map<String, List<Hours>> get hours => _hours;
  TimeNotifier();
  Future<void> pullHours(String name) async {
    if (!_hours.containsKey(name)) {
      _hours[name] = await fetchHoursFromDatabase(name);
    }
    notifyListeners();
  }

  void clearAll() {
    _hours.clear();
  }
}

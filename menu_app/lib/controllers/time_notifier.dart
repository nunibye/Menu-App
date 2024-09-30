import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';

class TimeNotifier extends ChangeNotifier {
  final Map<String, List<Hours>> _hours = {};
  final Map<String, Map<String, List<HoursEvent>>> _hoursEvents = {};
  Map<String, List<Hours>> get hours => _hours;
  Map<String, Map<String, List<HoursEvent>>> get hoursEvents => _hoursEvents;
  TimeNotifier();
  Future<void> pullHours(String name) async {
    if (!_hours.containsKey(name)) {
      final day = await fetchHoursFromDatabase(name);
      _hours[name] = day;
    }
    if (!_hoursEvents.containsKey(name)){
      _hoursEvents[name] = await fetchEventHours(name);
    }
    
    notifyListeners();
  }
}

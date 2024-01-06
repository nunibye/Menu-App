import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  List<String> colleges = [];

  SettingsController() {
    getCollegeOrder();
  }

  // Function changes the order of collges based on [collegeName], stored in
  // SharedPreferences [prefs], set as string ['collegesString'].
  changeCollegeOrder(collegeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('collegesString', collegeName);
  }

  // Function retrieves the order of colleges from SharedPreferences [prefs] and
  // sets the state of the [colleges] list.
  void getCollegeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString('collegesString');

    List<String> textList = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];

    // If there is no [text] saved, displays default order.
    if (text == null) {
    } else if (text.split(',').length == 4) {
    } else {
      textList = text.split(',');
    }
    colleges = textList;
    notifyListeners();
  }

  // Function reorders [colleges] based on [oldindex] and [newindex].
  void reorderData(int oldindex, int newindex) {
    if (newindex > oldindex) {
      newindex -= 1;
    }
    final items = colleges.removeAt(oldindex);
    colleges.insert(newindex, items);

    changeCollegeOrder(colleges.join(','));
    notifyListeners();
  }
}

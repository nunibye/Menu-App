// Displays the Settings Page to alow the user to change order each Hall is
// displayed in on the Home Page.

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// Function changes the order of collges based on [collegeName], stored in
// SharedPreferences [prefs], set as string ['collegesString'].
changeCollegeOrder(collegeName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('collegesString', collegeName);
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> colleges = [];

  // Function retrieves the order of colleges from SharedPreferences [prefs] and
  // sets the state of the [colleges] list.
  void getCollegeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString('collegesString');

    // If there is no [text] saved, displays default order.
    if (text == null) {
      List<String> textList = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];
      setState(() {
        colleges = textList;
      });
    }
    else if (text.split(',').length == 4) {
      List<String> textList = ['Merrill', 'Cowell', 'Nine', 'Porter', 'Oakes'];
      setState(() {
        colleges = textList;
      });
    } else {
      List<String> textList = text.split(',');
      setState(() {
        colleges = textList;
      });
    }
  }

  // Function reorders  [colleges] based on [oldindex] and [newindex].
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = colleges.removeAt(oldindex);
      colleges.insert(newindex, items);

      changeCollegeOrder(colleges.join(','));
    });
  }

  // Function called in home_page when widget is initialized.
  @override
  void initState() {
    super.initState();
    getCollegeOrder();
  }

  // Builds widget tree.
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // Displays app heading.
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: constants.menuHeadingSize,
                fontFamily: 'Monoton',
                color: Color(constants.yellowGold)),
          ),
          toolbarHeight: 60,
          centerTitle: false,
          backgroundColor: const Color(constants.darkBlue),
          shape:
              const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        ),
        body: Column(
          children: [
            // Displays title/
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: constants.borderWidth,
                          color: Color(constants.darkGray)))),
              padding: const EdgeInsets.only(
                  bottom: constants.containerPaddingTitle,
                  left: constants.containerPaddingTitle + 3,
                  right: constants.containerPaddingTitle),
              alignment: Alignment.bottomLeft,
              height: 50,
              child: const Text(
                "Change Layout",
                style: TextStyle(
                  fontFamily: constants.titleFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(constants.titleColor),
                  height: constants.titleFontheight,
                ),
              ),
            ),

            // Displays instructional text.
            Container(
              padding: const EdgeInsets.only(
                  top: 5,
                  left: constants.containerPaddingTitle + 3,
                  right: constants.containerPaddingTitle),
              alignment: Alignment.centerLeft,
              height: 35,
              child: const Text(
                "Press and drag to reorder home screen.",
                style: TextStyle(
                  fontFamily: constants.titleFont,
                  fontSize: 18,
                  color: Color(constants.titleColor),
                  height: constants.titleFontheight,
                ),
              ),
            ),

            // Displays the reordered data in a list.
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: constants.borderWidth,
                          color: Color(constants.darkGray)))),
              padding: const EdgeInsets.all(constants.containerPaddingTitle),
              alignment: Alignment.bottomLeft,
              height: 350,
              child: ReorderableListView(
                physics: const NeverScrollableScrollPhysics(),
                onReorder: reorderData,
                children: <Widget>[
                  for (final college in colleges)
                    Card(
                      color: const Color(constants.listColor),
                      key: ValueKey(college),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          college,
                          style: const TextStyle(
                            fontFamily: constants.titleFont,
                            fontWeight: FontWeight.bold,
                            fontSize: constants.titleFontSize,
                            color: Color(constants.titleColor),
                            height: constants.titleFontheight,
                          ),
                        ),
                        leading: const Icon(
                          Icons.menu,
                          color: Color(constants.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}

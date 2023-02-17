import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});
  final List<String> colleges = ["Merrill", "Cowell", "Nine", "Porter"];
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

addStringToSF(collegeNum, collegeName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(collegeNum, collegeName);
}

class _SettingsPageState extends State<SettingsPage> {
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = widget.colleges.removeAt(oldindex);
      widget.colleges.insert(newindex, items);
      for (var i = 0; i < widget.colleges.length; i++) {
        addStringToSF('college$i', widget.colleges[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: constants.borderWidth,
                          color: Color(constants.darkGray)))),
              padding: const EdgeInsets.all(constants.containerPaddingTitle),
              alignment: Alignment.bottomLeft,
              height: 50,
              child: const Text(
                "Change Layout",
                style: TextStyle(
                  fontFamily: constants.titleFont,
                  fontWeight: FontWeight.bold,
                  fontSize: constants.titleFontSize,
                  color: Color(constants.titleColor),
                  height: constants.titleFontheight,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: constants.borderWidth,
                          color: Color(constants.darkGray)))),
              padding: const EdgeInsets.all(constants.containerPaddingTitle),
              alignment: Alignment.bottomLeft,
              height: 280,
              child: ReorderableListView(
                physics: const NeverScrollableScrollPhysics(),
                onReorder: reorderData,
                children: <Widget>[
                  for (final college in widget.colleges)
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

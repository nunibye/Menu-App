// Displays the Settings Page to alow the user to change order each Hall is
// displayed in on the Home Page.

import 'package:flutter/material.dart';
import 'package:menu_app/controllers/settings_controller.dart';
import 'package:menu_app/views/nav_drawer.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart' as constants;
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsController(),
      builder: (context, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => context.go('/'),
          child: Scaffold(
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
              shape: const Border(
                  bottom: BorderSide(color: Colors.orange, width: 4)),
            ),
            body: Column(
              children: [
                // Displays title
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
                  height: 60,
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
                  padding:
                      const EdgeInsets.all(constants.containerPaddingTitle),
                  alignment: Alignment.bottomLeft,
                  height: 350,
                  child: ReorderableListView(
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder:
                        Provider.of<SettingsController>(context, listen: false)
                            .reorderData,
                    children: <Widget>[
                      for (final college in Provider.of<SettingsController>(
                              context,
                              listen: true)
                          .colleges)
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
            ),
          ),
        );
      },
    );
  }
}

// Page to load the Side Navagation Bar.

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});
  @override

  // Build navagation page.
  Widget build(BuildContext context) {
    // Get 2/3 of the screen size.
    double screenWidth = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
        width: screenWidth,
        child: Drawer(
          backgroundColor: const Color(constants.backgroundColor),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Padding.
              const SizedBox(
                height: 30,
              ),

              // Display Slug Menu image.
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: constants.borderWidth,
                            color: Color(constants.darkGray)))),
                height: (screenWidth * 0.75) * 0.8,
                child: Image(
                  image: const AssetImage('images/menu_header.png'),
                  width: screenWidth - 50,
                ),
              ),

              // Link to Homepage.
              ListTile(
                leading: const Icon(
                  Icons.house,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState?.onItemTapped(0)
                },
              ),

              // Link to Calculator.
              ListTile(
                leading: const Icon(
                  Icons.calculate,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Calculator',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState?.onItemTapped(5)
                },
              ),

              // Link to Settings Page
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState?.onItemTapped(6)
                },
              ),

              // Link to About Us page.
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'About Us',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {
                  Navigator.pop(context),
                  main_page.scakey.currentState?.onItemTapped(7)
                },
              ),
            ],
          ),
        ));
  }
}

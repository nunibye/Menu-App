import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'main.dart' as main_page;

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
        width: screenWidth,
        child: Drawer(
          backgroundColor: const Color(
              constants.backgroundColor), //Color.fromARGB(255, 18, 18, 18),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
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
              ListTile(
                leading: const Icon(
                  Icons.house,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    //fontWeight: FontWeight.bold,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {main_page.scakey.currentState?.onItemTapped(0)},
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    //fontWeight: FontWeight.bold,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {main_page.scakey.currentState?.onItemTapped(0)},
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(constants.menuColor),
                ),
                title: const Text(
                  'About',
                  style: TextStyle(
                    fontFamily: constants.menuFont,
                    //fontWeight: FontWeight.bold,
                    fontSize: constants.menuFontSize,
                    color: Color(constants.menuColor),
                    height: constants.menuFontheight,
                  ),
                ),
                onTap: () => {main_page.scakey.currentState?.onItemTapped(5)},
              ),
            ],
          ),
        ));
  }
}

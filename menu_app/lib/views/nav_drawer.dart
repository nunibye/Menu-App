import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_app/utilities/constants.dart' as constants;
// TODO make controller
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
                  if(ModalRoute.of(context)?.settings.name != "Home") {
                    context.pushReplacement('/')
                  }
                  else {
                    context.pop()
                  }
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
                  if(ModalRoute.of(context)?.settings.name != "Calculator") {
                    context.pushReplacement('/Calculator')
                  }
                  else {
                    context.pop()
                  }
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
                  if(ModalRoute.of(context)?.settings.name != "Settings") {
                    context.pushReplacement('/Settings')
                  }
                  else {
                    context.pop()
                  }
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
                  if(ModalRoute.of(context)?.settings.name != "About") {
                    context.pushReplacement('/About')
                  }
                  else {
                    context.pop()
                  }
                },
              ),
            ],
          ),
        ));
  }
}
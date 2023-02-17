import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: constants.menuHeadingSize,
              fontFamily: 'Monoton',
              color: Color(constants.yellowGold)),
        ),
        toolbarHeight: 60,
        centerTitle: false,
        backgroundColor: const Color(constants.darkBlue),
        shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        
        
        // leading: IconButton(
        //   onPressed: () {
        //     main_page.scakey.currentState?.onItemTapped(0);
        //   },
        //   icon: const Icon(Icons.arrow_back_ios_new_rounded,
        //       color: Colors.orange, size: constants.backArrowSize),
        // ),
    ));
  }
}
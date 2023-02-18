import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> contents = [
      "About us",
      "This app is created by Eliah Reeves and Christian Knab from Merrill.\n\nPlease share this app with your friends!\n",
      "Contact Us",
      "For issues, bugs, ideas, etc., email us at ucscmenuapp@gmail.com"
    ];
final imageSize = MediaQuery.of(context).size.width - 200;
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text(
            "About  Us",
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

          // leading: IconButton(
          //   onPressed: () {
          //     main_page.scakey.currentState?.onItemTapped(0);
          //   },
          //   icon: const Icon(Icons.arrow_back_ios_new_rounded,
          //       color: Colors.orange, size: constants.backArrowSize),
          // ),
        ),
        body: ListView(
          children: [ const SizedBox(height: 30),SizedBox(width: imageSize, height: imageSize, child: const Image( fit:BoxFit.scaleDown,
                  image: AssetImage('images/cone.png'),
                )),
            for (var i = 0; i < contents.length; i++)
              if (i % 2 == 0)
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: constants.borderWidth,
                              color: Color(constants.darkGray)))),
                  padding:
                      const EdgeInsets.all(constants.containerPaddingTitle),
                  alignment: Alignment.topLeft,
                  child: Text(
                    contents[i],
                    style: const TextStyle(
                      fontFamily: constants.titleFont,
                      fontWeight: FontWeight.bold,
                      fontSize: constants.titleFontSize,
                      color: Color(constants.titleColor),
                      height: constants.titleFontheight,
                    ),
                  ),
                )
              else
                (Container(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  // const EdgeInsets.all(
                  //     constants.containerPaddingbody),
                  alignment: Alignment.topLeft,
                  child: Text(
                    contents[i],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: constants.bodyFont,
                      //fontWeight: FontWeight.bold,
                      fontSize: constants.bodyFontSize,
                      color: Color(constants.bodyColor),
                      height: constants.bodyFontheight,
                    ),
                  ),
                ))
          ],
        ));
  }
}

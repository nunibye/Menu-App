// Displays the about page.

import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The text describing the app.
    final List<String> contents = [
      "About Us",
      "This app is created by Eliah Reeves and Christian Knab from Merrill.\n\nPlease share this app with your friends!\n",
      "Support Us",
      "Please help keep this app on the App Store by donating!\n"
    ];
    final imageSize = MediaQuery.of(context).size.width - 200;

    return Scaffold(
        // Display page heading.
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
        ),

        // Display company image.
        body: ListView(
          children: [
            const SizedBox(height: 30),
            SizedBox(
                width: imageSize,
                height: imageSize,
                child: const Image(
                  fit: BoxFit.scaleDown,
                  image: AssetImage('images/cone.png'),
                )),

            // Loop through [contents] list.
            for (var i = 0; i < contents.length; i++)

              // Even indicies must be headings
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

              // Odd indicies must be body text
              else
                (Container(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    contents[i],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: constants.bodyFont,
                      fontSize: constants.bodyFontSize,
                      color: Color(constants.bodyColor),
                      height: constants.bodyFontheight,
                    ),
                  ),
                )),
            SafeArea(
              child: Html(
                data:
                    '<div><a href="https://www.buymeacoffee.com/christiantknab" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" ></a></div>',
                // Styling with CSS (not real CSS)
                style: {
                  'div': Style(
                      textAlign: TextAlign.center,
                      margin: Margins.only(left: 50, right: 50)
                      // padding: const EdgeInsets.only(bottom: 20),
                      )
                },
                onLinkTap: (url, _, __) {
                  Uri uri = Uri.parse(url!);
                  launchUrl(uri).catchError((error) {
                    throw 'Could not launch $url: $error';
                  });
                },
              ),
            ),

            // Contact us body.
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: InkWell(
                child: const Text(
                  'For issues, bugs, ideas, etc., email us at ucscmenuapp@gmail.com',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: constants.bodyFont,
                    fontSize: constants.bodyFontSize,
                    color: Color(constants.bodyColor),
                    height: constants.bodyFontheight,
                  ),
                ),

                // Links text to mail app.
                onTap: () => launchUrl(
                  Uri(
                    scheme: 'mailto',
                    path: 'ucscmenuapp@gmail.com',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }
}

launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    //TODO handle this
    throw 'Could not launch $url';
  }
}

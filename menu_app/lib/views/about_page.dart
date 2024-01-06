// Displays the about page.
import 'package:flutter/material.dart';
import 'package:menu_app/views/nav_drawer.dart';
import '../utilities/constants.dart' as constants;
import 'package:url_launcher/url_launcher.dart';
import 'package:open_mail_app/open_mail_app.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The text describing the app.
    final List<String> contents = [
      "About Us",
      "This app is created by Eliah Reeves and Christian Knab from Merrill.\n",
      "Support Us",
      "Please help keep this app on the App Store by donating!",
    ];
    final imageSize = MediaQuery.of(context).size.width - 225;

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
                      fontSize: constants.bodyFontSize,
                    ),
                  ),
                )),
            // FIXME: idk about this sizing stuff...
            Padding(
              padding: const EdgeInsets.only(left: 90, right: 90, top: 10),
              child: ElevatedButton(
                onPressed: () => launchUrl(
                    Uri.parse('https://www.buymeacoffee.com/christiantknab')),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      constants.darkThemeColors(context).onSurface),
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      double.infinity, 40)), // Adjust the height (40) as needed
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Buy us a coffee! ',
                      style: TextStyle(
                        color: constants.darkThemeColors(context).background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\u2615', // emoji characters
                      style: TextStyle(
                        fontFamily: 'EmojiOne',
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color:
                                constants.darkThemeColors(context).onBackground,
                            offset: Offset(0, 0),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contact us body.
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              alignment: Alignment.topLeft,
              child: const Text(
                'For issues, bugs, ideas, etc., email us at ucscmenuapp@gmail.com.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: constants.bodyFontSize,
                ),
              ),
            ),
            // FIXME: idk about this sizing stuff...
            Padding(
              padding: const EdgeInsets.only(left: 120, right: 120, top: 10),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          constants.darkThemeColors(context).onSurface)),
                  onPressed: // Links text to mail app.
                      () async {
                    EmailContent email =
                        EmailContent(to: ["ucscmenuapp@gmail.com"]);
                    // Android: Will open mail app or show native picker.
                    // iOS: Will open mail app if single mail app found.
                    var result = await OpenMailApp.composeNewEmailInMailApp(
                      nativePickerTitle: 'Select email app to compose',
                      emailContent: email,
                    );

                    // If no mail apps found, show error
                    if (!result.didOpen && !result.canOpen) {
                      showNoMailAppsDialog(context);

                      // iOS: if multiple mail apps found, show dialog to select.
                    } else if (!result.didOpen && result.canOpen) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return MailAppPickerDialog(
                            mailApps: result.options,
                            emailContent: email,
                          );
                        },
                      );
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Email us! ',
                            style: TextStyle(
                              color:
                                  constants.darkThemeColors(context).background,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: '\uD83D\uDCE8', // emoji characters
                          style: TextStyle(
                            fontFamily: 'EmojiOne',
                            fontSize: 15,
                            shadows: [
                              Shadow(
                                color: constants
                                    .darkThemeColors(context)
                                    .onBackground, // Set the color to match your background
                                offset: Offset(0, 0),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Open Mail App"),
        content: const Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

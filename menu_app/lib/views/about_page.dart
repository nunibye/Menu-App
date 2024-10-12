// Displays the about page.
import 'package:flutter/material.dart';
import 'package:menu_app/controllers/about_controller.dart';
import 'package:menu_app/views/nav_drawer.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart' as constants;
import 'package:go_router/go_router.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AboutController(context: context),
      builder: (context, child) {
        // The text describing the app.
        final List<String> contents = [
          "About Us",
          "This app is created by Eliah Reeves and Christian Knab from Merrill.\n",
          "Support Us",
          "Please help keep this app on the App Store by donating!",
        ];
        final imageSize = MediaQuery.of(context).size.width - 225;

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => context.go('/'),
          child: Scaffold(
            // Display page heading.
            drawer: const NavDrawer(),
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                "About  Us",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: constants.menuHeadingSize,
                    fontFamily: 'Monoton',
                    color: Theme.of(context).colorScheme.primary),
              ),
              toolbarHeight: 60,
              centerTitle: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 4)),
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
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        contents[i],
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: constants.bodyFontSize,
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: ElevatedButton(
                    onPressed: () =>
                        Provider.of<AboutController>(context, listen: false)
                            .launchDonateLink(),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onSurface),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Buy us a coffee! ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '\u2615', // emoji characters
                          style: TextStyle(
                            fontFamily: 'EmojiOne',
                            fontSize: 15,
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
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.onSurface)),
                      onPressed: () =>
                          Provider.of<AboutController>(context, listen: false)
                              .openEmail(context),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Email us! ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme
                                      .surface,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                              text: '\uD83D\uDCE8', // emoji characters
                              style: TextStyle(
                                fontFamily: 'EmojiOne',
                                fontSize: 15,
                                shadows: [
                                  Shadow(
                                    color: Theme.of(context).colorScheme
                                        .onSurfaceVariant, // Set the color to match your background
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
            ),
          ),
        );
      },
    );
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
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}

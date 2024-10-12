// Displays the Settings Page to alow the user to change order each Hall is
// displayed in on the Home Page.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:menu_app/controllers/settings_controller.dart';
import 'package:menu_app/controllers/theme_provider.dart';
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
              title: Text(
                "Settings",
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
            body: ListView(
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
                const ThemeSettings(),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, controller, child) {
        return Column(
          children: [
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
                "Change Theme",
                style: TextStyle(
                  fontFamily: constants.titleFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(constants.titleColor),
                  height: constants.titleFontheight,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Default Theme",
                      style: TextStyle(
                        fontFamily: constants.titleFont,
                        fontSize: 18,
                        color: Color(constants.titleColor),
                        height: constants.titleFontheight,
                      ),
                    ),
                    CupertinoSwitch(
                      value: controller.isDefault,
                      onChanged: (val) => controller.toggleIsDefault(val),
                    )
                  ],
                )),
            if (!controller.isDefault)
              Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Primary Color",
                        style: TextStyle(
                          fontFamily: constants.titleFont,
                          fontSize: 18,
                          color: Color(constants.titleColor),
                          height: constants.titleFontheight,
                        ),
                      ),
                      _ColorPickerDisplay(
                          color: Theme.of(context).colorScheme.primary,
                          setColor:
                              Provider.of<ThemeProvider>(context).setPrimary),
                    ],
                  )),
            if (!controller.isDefault)
              Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Secondary Color",
                        style: TextStyle(
                          fontFamily: constants.titleFont,
                          fontSize: 18,
                          color: Color(constants.titleColor),
                          height: constants.titleFontheight,
                        ),
                      ),
                      _ColorPickerDisplay(
                          color: Theme.of(context).colorScheme.secondary,
                          setColor:
                              Provider.of<ThemeProvider>(context).setSecondary),
                    ],
                  ))
          ],
        );
      },
    );
  }
}

class _ColorPickerDisplay extends StatefulWidget {
  const _ColorPickerDisplay({required this.color, required this.setColor});
  final Color color;
  final void Function(Color) setColor;
  @override
  State<_ColorPickerDisplay> createState() => __ColorPickerDisplayState();
}

class __ColorPickerDisplayState extends State<_ColorPickerDisplay> {
  Color? pendingColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isDefault) {
              return;
            }
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Pick a color"),
                content: ColorPicker(
                  pickerColor: widget.color,
                  onColorChanged: (color) {
                    pendingColor = color;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (pendingColor != null) {
                        widget.setColor(pendingColor!);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Select"),
                  ),
                ],
              ),
            );
          },
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: Text("#${widget.color.toHexString()}"),
              ),
              Container(
                width: 25,
                height: 25,
                color: widget.color,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Loads the Summary Page to display College tiles and Summary below.

import 'package:flutter/material.dart';
import 'package:menu_app/custom_widgets/summary.dart';
import 'package:menu_app/custom_widgets/tab_bar.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_app/custom_widgets/banner.dart';
import 'package:menu_app/utilities/constants.dart' as constants;
import 'package:menu_app/views/nav_drawer.dart';
import 'package:menu_app/controllers/home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageController(context: context),
      builder: (context, child) {
        // Needs to be built before showing the update dialog
        double iconSizeCollege = MediaQuery.of(context).size.width / 2.7;

        return Scaffold(
          // Display app bar header.
          drawer: const NavDrawer(),
          appBar: AppBar(
            toolbarHeight: 60,
            centerTitle: true,
            backgroundColor: const Color(constants.darkBlue),
            surfaceTintColor: const Color.fromARGB(255, 60, 60, 60),
            title: const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "UC Santa Cruz",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                  fontFamily: 'Monoton',
                  color: Color(constants.yellowGold),
                ),
              ),
            ),
            shape: const Border(
                bottom: BorderSide(color: Colors.orange, width: 4)),
          ),
          body: RefreshIndicator(
            onRefresh:
                Provider.of<HomePageController>(context, listen: false).refresh,
            // indicatorBuilder: (context, controller) {
            // return const Icon(
            //   Icons.fastfood_outlined,
            //   color: Colors.blueGrey,
            //   size: 30,
            // );
            // return Image.asset(
            //   'images/slug.png',
            //   scale: 0.5,
            // );
            // },
            child: Consumer<HomePageController>(
              builder: (context, controller, child) => Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        buildBanner(),
                        // Display header text.
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 12),
                          child: const Text(
                            "Dining Halls",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Montserat',
                                fontWeight: FontWeight.w800,
                                color: Color(constants.yellowOrange)),
                          ),
                        ),
                        // Display all hall icons.
                        Container(
                          alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.width / 2.3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.colleges.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: IconButton(
                                    onPressed: () {
                                      context.push(
                                          '/${controller.colleges[index].trim()}');
                                    },
                                    icon: Image.asset(
                                        'images/${controller.colleges[index].trim()}.png'),
                                    iconSize: iconSizeCollege,
                                  ),
                                );
                              } else if (index ==
                                  controller.colleges.length - 1) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 7),
                                  child: IconButton(
                                    onPressed: () {
                                      context.push(
                                          '/${controller.colleges[index].trim()}');
                                    },
                                    icon: Image.asset(
                                        'images/${controller.colleges[index].trim()}.png'),
                                    iconSize: iconSizeCollege,
                                  ),
                                );
                              }
                              return IconButton(
                                onPressed: () {
                                  context.push(
                                      '/${controller.colleges[index].trim()}');
                                },
                                icon: Image.asset(
                                    'images/${controller.colleges[index].trim()}.png'),
                                iconSize: iconSizeCollege,
                              );
                            },
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(bottom: 6, top: 6),
                            child: CustomTabBar()),
                        buildSummaryList(
                            controller.colleges, controller.mealTime, controller.busyness),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "Last updated: ${Provider.of<HomePageController>(context, listen: false).time.toString().substring(5, 19)}\nData provided by nutrition.sa.ucsc.edu",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Page to load the Side Navagation Bar.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_app/controllers/hall_controller.dart';
import 'package:menu_app/controllers/time_notifier.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/custom_widgets/menu.dart';
import 'package:menu_app/views/time_modal_widget.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart' as constants;

class MenuPage extends StatefulWidget {
  final bool hasLateNight;
  final String name;

  const MenuPage({required this.name, required this.hasLateNight, super.key});

  // Not sure if this should be changed here. TickerProviderStateMixin is weird...
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HallController(
        name: widget.name,
        hasLateNight: widget.hasLateNight,
        vsync: this,
      ),
      builder: (context, child) {
        return Scaffold(
          // Hours info tab.
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _timeModalBottom(context,
                  Provider.of<HallController>(context, listen: false).name);
            },
            shape: const CircleBorder(),
            enableFeedback: true,
            backgroundColor: const Color.fromARGB(255, 94, 94, 94),
            child: const Icon(
              Icons.access_time_outlined,
              color: Colors.white,
            ),
          ),

          // App heading.
          appBar: AppBar(
            title: Text(
              Provider.of<HallController>(context, listen: false).name,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: constants.menuHeadingSize,
                  fontFamily: 'Monoton',
                  color: Color(constants.yellowGold)),
            ),
            toolbarHeight: 60,
            centerTitle: false,
            backgroundColor: const Color(constants.darkBlue),
            // shape: const Border(
            //     bottom: BorderSide(color: Colors.orange, width: 4)),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.orange, size: constants.backArrowSize),
            ),

            // Choose later date
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      padding: const EdgeInsets.only(right: 10),
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: const Color.fromARGB(255, 37, 37, 37),
                      value: Provider.of<HallController>(context, listen: true)
                          .currentlySelected,
                      alignment: Alignment.center,
                      onChanged: (newValue) {
                        Provider.of<HallController>(context, listen: false)
                            .changeDay(newValue);
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return Provider.of<HallController>(context,
                                listen: false)
                            .dropdownValues
                            .map<Widget>((String item) {
                          // This is the widget that will be shown when you select an item.
                          // Here custom text style, alignment and layout size can be applied
                          // to selected item string.
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  color: Color(constants.bodyColor),
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList();
                      },
                      items: Provider.of<HallController>(context, listen: false)
                          .dropdownValues
                          .map((date) {
                        return DropdownMenuItem(
                          alignment: Alignment.centerLeft,
                          value: date,
                          child: Text(
                            date,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            ],

            bottom: TabBar(
              dividerColor: Colors.orange,
              dividerHeight: 2,
              indicator: CustomTabIndicator(),
              labelColor: const Color(constants.bodyColor),
              unselectedLabelColor: const Color(constants.bodyColor),
              indicatorSize: TabBarIndicatorSize.tab,
              splashBorderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              controller: Provider.of<HallController>(context, listen: false)
                  .tabController,
              tabs: <Widget>[
                const Tab(
                  icon: Icon(Icons.egg_alt_outlined),
                ),
                const Tab(
                  icon: Icon(Icons.fastfood_outlined),
                ),
                const Tab(
                  icon: Icon(Icons.dinner_dining_outlined),
                ),
                if (Provider.of<HallController>(context, listen: false)
                    .hasLateNight)
                  const Tab(
                    icon: Icon(
                      Icons.bedtime_outlined,
                    ),
                  ),
              ],
            ),
          ),

          body: TabBarView(
            controller: Provider.of<HallController>(context, listen: false)
                .tabController,
            children: <Widget>[
              buildMeal(Provider.of<HallController>(context, listen: false)
                  .futureBreakfast),
              buildMeal(Provider.of<HallController>(context, listen: false)
                  .futureLunch),
              buildMeal(Provider.of<HallController>(context, listen: false)
                  .futureDinner),
              if (Provider.of<HallController>(context, listen: false)
                  .hasLateNight)
                buildMeal(Provider.of<HallController>(context, listen: false)
                    .futureLateNight),
            ],
          ),
        );
      },
    );
  }
}

// Displays Hall default weekly hours.
void _timeModalBottom(context, String name) {
  showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      context: context,
      builder: (BuildContext context) {
        return TimeModalWidget(
          width: MediaQuery.sizeOf(context).width,
          name: name,
        );
      });
}

// class CustomTabIndicator extends Decoration {
//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return _CustomPainter();
//   }
// }

// class _CustomPainter extends BoxPainter {
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final Rect rect = offset & configuration.size!;
//     final Paint paint = Paint();
//     paint.color = Colors.orange;
//     paint.style = PaintingStyle.fill;

//     final double indicatorHeight = 4;
//     final double radius = indicatorHeight / 2;

//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromPoints(
//           rect.bottomLeft,
//           rect.bottomRight.translate(0, -indicatorHeight),
//         ),
//         topLeft: Radius.circular(radius),
//         topRight: Radius.circular(radius),
//       ),
//       paint,
//     );
//   }
// }
class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter();
  }
}

class _CustomPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint();
    paint.color = Colors.orange;
    paint.style = PaintingStyle.fill;

    final double indicatorHeight = 4;
    final double radius = indicatorHeight / 2;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          rect.bottomLeft,
          rect.bottomRight.translate(0, -indicatorHeight),
        ),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      paint,
    );
  }
}

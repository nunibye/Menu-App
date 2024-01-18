import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menu_app/controllers/home_page_controller.dart';
import 'package:menu_app/views/home_page.dart';
import 'package:provider/provider.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
        width: width,
        height: 30, // Adjust the height as needed
        child: const Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Button(text: "Breakfast", index: 0),
              _Button(text: "Lunch", index: 1),
              _Button(text: "Dinner", index: 2),
              _Button(text: "Late Night", index: 3),
              //_Button(text: AppLocalizations.of(context)!.oldTab, index: 3),
            ],
          ),
        ));
  }
}

class _Button extends StatelessWidget {
  final String text;
  final int index;

  const _Button({required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isActive =
        Provider.of<HomePageController>(context, listen: true).index == index;
    return GestureDetector(
      onTap: () => Provider.of<HomePageController>(context, listen: false)
          .onTabPressed(index),
      child: SizedBox(
          width: width * 0.23,
          child: Center(
              child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.onBackground
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ))),
    );
  }
}

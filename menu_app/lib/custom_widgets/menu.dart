import 'dart:async';
import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/utilities/constants.dart' as constants;
import 'package:menu_app/views/nutrition_page.dart';

// FIXME to controller
Widget buildMeal(Future<List<FoodCategory>> hallSummary) {
  return Container(
    padding: const EdgeInsets.only(left: 12, right: 12, top: 0),
    alignment: Alignment.topLeft,
    child: FutureBuilder(
      future: hallSummary,
      builder: (context, snapshot) {
        // Display the [hallSummary] data.
        if (snapshot.hasData) {
          // Display ['Hall Closed'] if there is no data in [hallSummary].
          if (snapshot.data![0].foodItems.isEmpty) {
            return Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: Text('Hall Closed', style: constants.containerTextStyle),
            );

            // Display the food categories and food items.
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(
                  top: 12, bottom: constants.containerPaddingTitle),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.only(
                      left: 14, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 30, 30),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the food category.
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            category.category,
                            style: constants.containerTextStyle.copyWith(
                              fontSize: constants.titleFontSize - 2,
                            ),
                          ),
                        ),
                        // Display the food items.
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: category.foodItems.map((foodItem) {
                            return InkWell(
                                onTap: () {
                                  // context.pushNamed(
                                  //   "Nutrition",
                                  //   extra: foodItem,
                                  // );
                                  // FIXME gorouter no worky?
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          NutritionPage(foodItem: foodItem),
                                    ),
                                  );
                                },
                                child: Row(children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        foodItem.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: constants.containerTextStyle
                                            .copyWith(
                                                fontSize:
                                                    constants.bodyFontSize - 2,
                                                height:
                                                    constants.bodyFontheight,
                                                fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  for (String allergy
                                      in foodItem.nutritionalInfo.tags)
                                    // TODO FIXME when eric fixes scraper
                                    if (allergy != "" &&
                                        allergy != "Gluten Friendly" &&
                                        allergy != "Tree Nut" &&
                                        allergy != "Peanuts" &&
                                        allergy != "Vegetarian" &&
                                        allergy != "Egg")
                                      Padding(
                                        padding: EdgeInsets.only(left: 2),
                                        child: ClipOval(
                                          child: Image.asset(
                                            'icons/${allergy.toLowerCase()}.gif',
                                            isAntiAlias: true,
                                            fit: BoxFit.contain,
                                            scale: 1.25,
                                          ),
                                        ),
                                      ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 13,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ]));
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // If there is an error, display error.
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.only(top: constants.containerPaddingbody),
            alignment: Alignment.topCenter,
            child: Text(
              "Could not connect... Please retry.",
              textAlign: TextAlign.center,
              style: constants.containerTextStyle.copyWith(
                fontFamily: constants.bodyFont,
                fontSize: constants.bodyFontSize,
                height: constants.bodyFontheight,
              ),
            ),
          );
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    ),
  );
}

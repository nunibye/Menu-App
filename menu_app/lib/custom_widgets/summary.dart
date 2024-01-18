import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/utilities/constants.dart' as constants;

Widget buildSummaryList(List<String> colleges, String mealTime) {
  return FutureBuilder(
      future: fetchSummaryList(colleges, mealTime),
      builder: (context, summarySnap) {
        return Column(
          children: <Widget>[
            for (int index = 0;
                index < colleges.length && index < colleges.length;
                index++)
              Container(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
                alignment: Alignment.topLeft,
                child: TextButton(
                  // Give each [college] a button to lead to the full summary page.
                  onPressed: () {
                    context.push('/${colleges[index].trim()}');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 30, 30, 30)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: constants.borderWidth,
                              color: Color(constants.darkGray),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            top: 8, bottom: constants.containerPaddingTitle),
                        alignment: Alignment.topLeft,
                        child: Text(colleges[index],
                            style: constants.containerTextStyle),
                      ),

                      // Check if snapshot data is not null before accessing its elements
                      if (summarySnap.data != null &&
                          summarySnap.data!
                              .isNotEmpty) // Display all the food categories and items.
                        // for (var foodCategory in summarySnap.data!)
                        if (summarySnap.data![index].foodItems.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var foodItem
                                  in summarySnap.data![index].foodItems)
                                Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    foodItem,
                                    textAlign: TextAlign.left,
                                    style:
                                        constants.containerTextStyle.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: constants.bodyFont,
                                      fontSize: constants.bodyFontSize,
                                      height: constants.bodyFontheight,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        else
                          Container(
                            padding: const EdgeInsets.only(
                                top: constants.containerPaddingbody),
                            alignment: Alignment.center,
                            child: Text(
                              "Hall Closed",
                              textAlign: TextAlign.center,
                              style: constants.containerTextStyle.copyWith(
                                fontFamily: constants.bodyFont,
                                fontSize: constants.bodyFontSize,
                                height: constants.bodyFontheight,
                              ),
                            ),
                          )
                      else if (summarySnap.hasError)
                        Container(
                          padding: const EdgeInsets.only(
                              top: constants.containerPaddingbody),
                          alignment: Alignment.center,
                          child: Text(
                            "Could not connect... Please retry.",
                            textAlign: TextAlign.center,
                            style: constants.containerTextStyle.copyWith(
                              fontFamily: constants.bodyFont,
                              fontSize: constants.bodyFontSize,
                              height: constants.bodyFontheight,
                            ),
                          ),
                        )
                      else
                        // By default, show a loading spinner.
                        const Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: CircularProgressIndicator())),
                    ],
                  ),
                ),
              ),
          ],
        );
      });
}

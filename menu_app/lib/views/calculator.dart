// Displays the slug points calculator.

import 'package:flutter/material.dart';
import 'package:menu_app/controllers/calculator_controller.dart';
import 'package:menu_app/views/nav_drawer.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart' as constants;
import 'package:intl/intl.dart';

// Function to create a text widget with an oval background.
Widget summaryWidget(String label, String result) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 30, 30, 30),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10, right: 10),
          child: Text(
            result,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    ],
  );
}

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorController(),
      builder: (context, child) {
        return GestureDetector(
            onTap: () =>
                Provider.of<CalculatorController>(context, listen: false)
                    .hideKeyboard(),
            child: Scaffold(
              // Create [FloatingActionButton] which describes how to use the caclulator.
              floatingActionButton: FloatingActionButton(
                // Open description when [floatingActionButton] is pressed.
                onPressed: () {
                  _timeModalBottom(context);
                },
                shape: const CircleBorder(),
                enableFeedback: true,
                backgroundColor: const Color.fromARGB(255, 94, 94, 94),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),

              // Display page heading.
              drawer: const NavDrawer(),
              appBar: AppBar(
                title: const Text(
                  "Calculator",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: constants.menuHeadingSize,
                      fontFamily: 'Monoton',
                      color: Color(constants.yellowGold)),
                ),
                toolbarHeight: 60,
                centerTitle: false,
                backgroundColor: const Color(constants.darkBlue),
                shape: const Border(
                    bottom: BorderSide(color: Colors.orange, width: 4)),
              ),

              // Display calculator page body.
              body: Container(
                color: const Color(constants.darkBlue),
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Form(
                    // Allows keyboard to dismiss on drag
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      children: <Widget>[
                        const SizedBox(
                          height: 60,
                        ),

                        // Textbox form for [dateController].
                        TextFormField(
                          controller: Provider.of<CalculatorController>(context,
                                  listen: false)
                              .dateController, //editing controller of this TextField
                          decoration: constants.customInputDecoration.copyWith(
                            labelText: "Last Day", //label text of field
                          ),

                          // User cannot edit text. Rather, a calendar popup appears.
                          // The user can pick a date from the calendar.
                          readOnly: true,
                          style: const TextStyle(
                              color: Color(constants.bodyColor)),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(
                                  Provider.of<CalculatorController>(context,
                                          listen: false)
                                      .dateController
                                      .text),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            // Format date and set the [dateController] text.
                            if (pickedDate != null) {
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed.
                              Provider.of<CalculatorController>(context,
                                      listen: false)
                                  .updateMealDate(formattedDate);
                            }
                          },
                        ),

                        // Padding between [TextFormField]s.
                        const SizedBox(
                          height: 20,
                        ),

                        // Textbox form for [_totalSlugPointsController].
                        TextFormField(
                          key: const Key("totalSlugPoints"),
                          controller: Provider.of<CalculatorController>(context,
                                  listen: false)
                              .totalSlugPointsController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                            color: Color(constants.bodyColor),
                          ),
                          decoration: constants.customInputDecoration.copyWith(
                            hintText: 'Balance',
                            labelText: 'Slug points',
                          ),
                          onChanged: (s) => Provider.of<CalculatorController>(
                                  context,
                                  listen: false)
                              .updateTotalSlugPoints(),
                        ),

                        // Padding between [TextFormField]s.
                        const SizedBox(
                          height: 20,
                        ),

                        // Textbox form for [_mealCostController].
                        TextFormField(
                          key: const Key("totalMealCost"),
                          controller: Provider.of<CalculatorController>(context,
                                  listen: false)
                              .mealCostController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                              color: Color(constants.bodyColor)),
                          decoration: constants.customInputDecoration.copyWith(
                            hintText: 'Cost',
                            labelText: 'Meal Cost',
                          ),
                          onChanged: (s) => Provider.of<CalculatorController>(
                                  context,
                                  listen: false)
                              .updateMealCost(),
                        ),

                        // Padding between [TextFormField]s.
                        const SizedBox(
                          height: 25,
                        ),

                        // Textbox form for [_mealDayController].
                        TextFormField(
                          key: const Key("mealsDay"),
                          controller: Provider.of<CalculatorController>(context,
                                  listen: false)
                              .mealDayController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Color(constants.bodyColor)),
                          decoration: constants.customInputDecoration.copyWith(
                            hintText: 'Meals',
                            labelText: 'Meals per day',
                          ),
                          onChanged: (s) => Provider.of<CalculatorController>(
                                  context,
                                  listen: false)
                              .updateMealDay(),
                        ),
                        // Summary description based on user input.
                        Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              summaryWidget('Days Left:',
                                  '${Provider.of<CalculatorController>(context, listen: true).getDays()}'),
                              const SizedBox(
                                height: 8,
                              ),
                              summaryWidget(
                                  'Extra Meals:',
                                  Provider.of<CalculatorController>(context,
                                          listen: true)
                                      .getMealAmount()),
                              const SizedBox(
                                height: 8,
                              ),
                              summaryWidget(
                                  'Extra Points:',
                                  Provider.of<CalculatorController>(context,
                                          listen: true)
                                      .getPointsAmount()),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'You can eat ${Provider.of<CalculatorController>(context, listen: true).getMealDayAmount()} per day',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}

// Function [_timeModalBottom] opens [FloatingActionButton] calculator description.
void _timeModalBottom(context) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      context: context,
      builder: (context) => DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("How to Use",
                            style: TextStyle(
                              fontFamily: constants.bodyFont,
                              fontWeight: FontWeight.bold,
                              fontSize: constants.titleFontSize - 5,
                              color: Colors.black,
                              height: constants.bodyFontheight,
                            ))),
                    const SizedBox(
                      width: constants.sizedBox,
                      child: Text(
                        "Enter the last day of the quarter you plan to eat, "
                        "How many slug points you have, and how many meals you "
                        "eat per day. \n\nDays left tells you how "
                        "many days until the date you enter.\n\nExtra Meals tells "
                        "how many meals leftover you will have at your current "
                        "rate.\n\nExtra Slug Points tells how many slugpoints you "
                        "will have left over.\n\nThe Final line tells how many "
                        "meals you could be eating per day.\n\nNote: These values "
                        "are estimates and do not consider changes in pricing "
                        "during finals week.",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ),
            ),
          ));
}

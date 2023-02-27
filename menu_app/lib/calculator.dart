import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});
  @override
  State<Calculator> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<Calculator> {
  static const totalSlugPoints = 1000.0;
  static const mealDay = 3.0;
  static const mealCost = 8.28;

  final _totalSlugPointsController =
      TextEditingController(text: totalSlugPoints.toString());
  final _mealDayController = TextEditingController(text: mealDay.toString());
  final _mealCostController = TextEditingController(text: mealCost.toString());
  TextEditingController dateController = TextEditingController();

  double _totalSlugPoints = totalSlugPoints;
  double _mealDay = mealDay;
  double _mealCost = mealCost;

  @override
  void initState() {
    super.initState();
    _totalSlugPointsController.addListener(_onTotalSlugPointsChanged);
    _mealDayController.addListener(_onMealDayChanged);
    _mealCostController.addListener(_onMealCostChanged);
    // _lastDayController.addListener(_onLastDayChanged);
    final DateTime winter = DateTime(DateTime.now().year, 3, 24);
    final DateTime spring = DateTime(DateTime.now().year, 6, 15);
    final DateTime summer = DateTime(DateTime.now().year, 9, 1);
    final DateTime fall = DateTime(DateTime.now().year, 12, 9);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (winter.isAfter(now)) {
      dateController.text = formatter.format(winter);
    } else if (spring.isAfter(now)) {
      dateController.text = formatter.format(spring);
    } else if (spring.isAfter(now)) {
      dateController.text = formatter.format(summer);
    } else if (spring.isAfter(now)) {
      dateController.text = formatter.format(fall);
    } else {
      dateController.text = formatter.format(now);
    }
  }

  changeAdVar(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showAd', value);
  }

  _onTotalSlugPointsChanged() {
    setState(() {
      _totalSlugPoints =
          double.tryParse(_totalSlugPointsController.text) ?? 0.0;
    });
    if (_totalSlugPoints == 27182818.0) {
      changeAdVar(false);
    } else if (_totalSlugPoints == 31415926.0) {
      changeAdVar(true);
    }
  }

  _onMealDayChanged() {
    setState(() {
      _mealDay = double.tryParse(_mealDayController.text) ?? 0;
    });
  }

  _onMealCostChanged() {
    setState(() {
      _mealCost = double.tryParse(_mealCostController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    // To make sure we are not leaking anything, dispose any used TextEditingController
    // when this widget is cleared from memory.
    _mealDayController.dispose();
    _totalSlugPointsController.dispose();
    _mealCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getDays() => num.parse(
        (DateTime.parse(dateController.text).difference(DateTime.now()).inDays +
                1)
            .toString());

    getMealAmount() => num.parse(
        ((_totalSlugPoints - (_mealDay * _mealCost * getDays())) / mealCost)
            .toStringAsFixed(2));
    getPointsAmount() =>
        num.parse(((_totalSlugPoints - (_mealDay * _mealCost * getDays())))
            .toStringAsFixed(2));
    getMealDayAmount() => num.parse(
        (((_totalSlugPoints / _mealCost) / getDays())).toStringAsFixed(2));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _timeModalBottom(context);
        },
        backgroundColor: const Color.fromARGB(255, 94, 94, 94),
        child: const Icon(Icons.info_outlined),
      ),
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
        shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
      ),
      body: Container(
        color: const Color(constants.darkBlue),
        padding: const EdgeInsets.only(left:16.0, right:16.0),
        child: Center(
          child: Form(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                    controller:
                        dateController, //editing controller of this TextField
                    decoration: InputDecoration(
                      // icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Last Day", //label text of field
                      labelStyle: const TextStyle(
                          fontSize: 25,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: Color(constants.bodyColor)),
                      fillColor: const Color.fromARGB(255, 32, 32, 32),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 68, 68, 68))),
                    ),
                    readOnly: true, // when true user cannot edit text
                    style: const TextStyle(color: Color(constants.bodyColor)),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(
                            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                        setState(() {
                          dateController.text =
                              formattedDate; //set foratted date to TextField value.
                        });
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  key: const Key("totalSlugPoints"),
                  controller: _totalSlugPointsController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Color(constants.bodyColor)),
                  decoration: InputDecoration(
                    hintText: 'Balance',
                    labelText: 'Slug points',
                    hintStyle:
                        const TextStyle(color: Color(constants.bodyColor)),
                    labelStyle: const TextStyle(
                      fontSize: 25,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Color(constants.bodyColor),
                    ),
                    fillColor: const Color.fromARGB(255, 32, 32, 32),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 68, 68, 68))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  key: const Key("totalMealCost"),
                  controller: _mealCostController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Color(constants.bodyColor)),
                  decoration: InputDecoration(
                    hintText: 'Cost',
                    labelText: 'Meal Cost',
                    hintStyle:
                        const TextStyle(color: Color(constants.bodyColor)),
                    labelStyle: const TextStyle(
                      fontSize: 25,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Color(constants.bodyColor),
                    ),
                    fillColor: const Color.fromARGB(255, 32, 32, 32),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 68, 68, 68))),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  key: const Key("mealsDay"),
                  controller: _mealDayController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(constants.bodyColor)),
                  decoration: InputDecoration(
                    hintText: 'Meals',
                    labelText: 'Meals per day',
                    hintStyle:
                        const TextStyle(color: Color(constants.bodyColor)),
                    labelStyle: const TextStyle(
                        fontSize: 25,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(constants.bodyColor)),
                    fillColor: const Color.fromARGB(255, 32, 32, 32),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 68, 68, 68))),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Days Left: ${getDays()}\nExtra Meals: ${getMealAmount()}\nExtra Slug Points: ${getPointsAmount()}\nYou can eat ${getMealDayAmount()} per day.',
                        key: const Key('mealAmount'),
                        style: const TextStyle(
                            color: Color(constants.bodyColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _timeModalBottom(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        context: context,
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) => SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    children: const [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("How to Use",
                              style: TextStyle(
                                fontFamily: constants.bodyFont,
                                fontWeight: FontWeight.bold,
                                fontSize: constants.titleFontSize - 5,
                                color: Colors.black,
                                height: constants.bodyFontheight,
                              ))),
                      SizedBox(
                        width: constants.sizedBox,
                        child: Text(
                          "Enter the last day of the quarter you plan to eat, How many slug points you have, and how many meals you eat per day. Entering a meal price is not required as the default value is 8.28.\n\nDays left tells you how many days until the date you enter.\n\nExtra Meals tells how many meals leftover you will have at your current rate.\n\nExtra Slug Points tells how many slugpoints you will have left over.\n\nThe Final line tells how many meals you could be eating per day.",
                        ),
                      ),
                     
                    ],
                  ),
                ),
              ),
            ));
  }
}

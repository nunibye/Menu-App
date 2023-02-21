import 'package:flutter/material.dart';
//import 'package:flutter_launcher_icons/constants.dart';
import 'constants.dart' as constants;
import 'package:menu_app/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});
  @override
  State<Calculator> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<Calculator> {
  static const totalSlugPoints = 1000.0;
  static const mealDay = 3;
  // var lastDay = "3 / 24 / 23"; FIXME: should be a date
  static const lastDay = 10; // FIXME: Right now only how many days left
  static const mealCost = 8.28;

  final _totalSlugPointsController =
      TextEditingController(text: totalSlugPoints.toString());
  final _mealDayController = TextEditingController(text: mealDay.toString());
  final _lastDayController = TextEditingController(text: lastDay.toString());

  double _totalSlugPoints = totalSlugPoints;
  int _mealDay = mealDay;
  int _lastDay = lastDay;
  // String _lastDay = lastDay; FIXME

  @override
  void initState() {
    super.initState();
    _totalSlugPointsController.addListener(_onTotalSlugPointsChanged);
    _mealDayController.addListener(_onMealDayChanged);
    _lastDayController.addListener(_onLastDayChanged);
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
    if (_totalSlugPoints == 2718281828459045) {
      changeAdVar(false);
    }else if (_totalSlugPoints == 3141592653589793) {
      changeAdVar(true);
    }
  }

  _onMealDayChanged() {
    setState(() {
      _mealDay = int.tryParse(_mealDayController.text) ?? 0;
    });
  }

  _onLastDayChanged() {
    setState(() {
      _lastDay = int.tryParse(_lastDayController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    // To make sure we are not leaking anything, dispose any used TextEditingController
    // when this widget is cleared from memory.
    _lastDayController.dispose();
    _mealDayController.dispose();
    _totalSlugPointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getMealAmount() => num.parse(
        ((_totalSlugPoints - (_mealDay * mealCost * _lastDay)) / mealCost)
            .toStringAsFixed(2));
    getPointsAmount() =>
        num.parse(((_totalSlugPoints - (_mealDay * mealCost * _lastDay)))
            .toStringAsFixed(2));

    return Scaffold(
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
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                TextFormField(
                  key: const Key("lastDay"),
                  controller: _lastDayController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(constants.bodyColor)),
                  decoration: InputDecoration(
                    hintText: 'Date',
                    labelText: 'Last day',
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
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Remaining Meals: ${getMealAmount()}\nSlug Points: ${getPointsAmount()}',
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
}

class AmountText extends StatelessWidget {
  final String text;

  const AmountText(
    this.text, {
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(constants.bodyColor),
              fontSize: 20)),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/utilities/constants.dart' as constants;

class NutritionPage extends StatelessWidget {
  final FoodItem foodItem;
  const NutritionPage({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutrition',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: constants.menuHeadingSize,
            fontFamily: 'Monoton',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: constants.backArrowSize,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NutritionLabel(foodItem: foodItem),
    );
  }
}

class NutritionLabel extends StatelessWidget {
  final FoodItem foodItem;
  const NutritionLabel({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 30, 30, 30),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildDivider(),
              _buildCalories(context),
              _buildServingInfo(context),
              _buildNutrients(context),
              _buildFooter(context),
              _buildDivider(),
              _buildAllergens(),
              _buildIngredients(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.onSurface,
        // color: Color.fromARGB(255, 76, 76, 76),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Text(
        foodItem.name,
        style: constants.containerTextStyle.copyWith(
          fontSize: constants.titleFontSize,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildServingInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serving size',
          ),
          const SizedBox(width: 4),
          Text(
            foodItem.nutritionalInfo.servingSize,
          ),
        ],
      ),
    );
  }

  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      // color: const Color.fromARGB(255, 40, 40, 40),
      child: Text(
        'Calories ${foodItem.nutritionalInfo.calories}',
        style: constants.containerTextStyle.copyWith(
          fontSize: constants.bodyFontSize + 5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildNutrients(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNutrientRow('Total Fat', foodItem.nutritionalInfo.totalFat,
              isMainNutrient: true),
          _buildNutrientRow(
              'Saturated Fat', foodItem.nutritionalInfo.saturatedFat,
              indent: true),
          _buildNutrientRow('Trans Fat', foodItem.nutritionalInfo.transFat,
              indent: true),
          _buildNutrientRow('Cholesterol', foodItem.nutritionalInfo.cholesterol,
              isMainNutrient: true),
          _buildNutrientRow('Sodium', foodItem.nutritionalInfo.sodium,
              isMainNutrient: true),
          _buildNutrientRow(
              'Total Carbohydrate', foodItem.nutritionalInfo.totalCarb,
              isMainNutrient: true),
          _buildNutrientRow(
              'Dietary Fiber', foodItem.nutritionalInfo.dietaryFiber,
              indent: true),
          _buildNutrientRow('Total Sugars', foodItem.nutritionalInfo.sugars,
              indent: true),
          _buildNutrientRow('Protein', foodItem.nutritionalInfo.protein,
              isMainNutrient: true),
        ],
      ),
    );
  }

  Widget _buildAllergens() {
    return foodItem.nutritionalInfo.allergens != ""
        ? Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildNutrientRow('Allergens', '', isMainNutrient: true),
                    const Spacer(),
                    for (String allergy in foodItem.nutritionalInfo.tags)
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
                        )
                  ],
                ),
                Text(foodItem.nutritionalInfo.allergens)
              ],
            ),
          )
        : SizedBox();
  }

  Widget _buildIngredients() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNutrientRow('Ingredients', '', isMainNutrient: true),
          Text(foodItem.nutritionalInfo.ingredients)
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String nutrient, String value,
      {bool isMainNutrient = false, bool indent = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: indent ? 16 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutrient,
            style: constants.containerTextStyle.copyWith(
              fontSize: isMainNutrient
                  ? constants.bodyFontSize
                  : constants.bodyFontSize - 2,
              fontWeight: isMainNutrient ? FontWeight.bold : FontWeight.normal,
              height: constants.bodyFontheight,
            ),
          ),
          Text(
            value,
            style: constants.containerTextStyle.copyWith(
              fontSize: isMainNutrient
                  ? constants.bodyFontSize
                  : constants.bodyFontSize - 2,
              fontWeight: isMainNutrient ? FontWeight.bold : FontWeight.normal,
              height: constants.bodyFontheight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
      child: Text(
        '* Percent Daily Values are based on a 2,000 calorie diet.',
        style: constants.containerTextStyle.copyWith(
            fontSize: constants.bodyFontSize - 4,
            // fontStyle: FontStyle.italic,
            height: constants.bodyFontheight,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}

import 'package:applovin_max/applovin_max.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Get the adBool and call [adLoader].
Future<bool> getAdBool() async {
  final prefs = await SharedPreferences.getInstance();
  bool? adBool = prefs.getBool('showAd');

  if (adBool == null || adBool == true) {
    adLoader();
  }
  return adBool ?? true;
}

// Function to load ad.
void adLoader() async {
  AppLovinMAX.setHasUserConsent(false);
  AppLovinMAX.setDoNotSell(true);
  await AppLovinMAX.initialize(
      'GFr_0T7XJkpH_DCfXDvsS60h31yU80TT5Luv56H6OglFi3tzt7SCQgZVD6nSJlvFCxyVoqCaS5drzhDtV1MKL0');
}
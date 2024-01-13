import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/utilities/ad_helper.dart' as ad_helper;

class AdBarController extends ChangeNotifier {
  double adHeight = 1;
  bool showAd = true;

  AdBarController() {
    // Initialize _showAd asynchronously
    getAdBool().then((value) {
      showAd = value;
      notifyListeners();
    });

    // Load ad based on initial state
    if (showAd) {
      loadAd();
    }
  }

  void loadAd() {
    // Update _adHeight and _showAd based on ad loading status
    if (ad_helper.getDevice == 'android') {
      adHeight = 50;
    } else if (ad_helper.getDevice == 'ios') {
      adHeight = 70;
    } else {
      adHeight = 0;
    }
    notifyListeners();
  }
}

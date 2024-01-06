import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/utilities/ad_helper.dart' as ad_helper;

class AdBarController extends ChangeNotifier {
  double _adHeight = 1;
  bool _showAd = true;

  double get adHeight => _adHeight;
  bool get showAd => _showAd;

  AdBarController() {
    // Initialize _showAd asynchronously
    getAdBool().then((value) {
      _showAd = value;
      notifyListeners();
    });

    // Load ad based on initial state
    if (_showAd) {
      loadAd();
    }
  }

  void loadAd() {
    // Update _adHeight and _showAd based on ad loading status
    if (ad_helper.getDevice == 'android') {
      _adHeight = 50;
    } else if (ad_helper.getDevice == 'ios') {
      _adHeight = 70;
    } else {
      _adHeight = 0;
    }
    notifyListeners();
  }
}

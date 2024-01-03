import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menu_app/utilities/ad_helper.dart' as ad_helper;
// FIXME make controller so it works
Widget adBar() {
  double rh = 1;
  bool adBool = true;

  return Container(
    //color: Colors.amber,
    alignment: Alignment.topCenter,
    height: rh,
    child: adBool
        ? MaxAdView(
            adUnitId: ad_helper.getAdUnitId,
            adFormat: AdFormat.banner,
            listener: AdViewAdListener(
                onAdLoadedCallback: (ad) {
                  if (ad_helper.getDevice == 'android') {
                    rh = 50;
                  } else if (ad_helper.getDevice == 'ios') {
                    rh = 70;
                  }
                },
                onAdLoadFailedCallback: (adUnitId, error) {
                  rh = 0;
                },
                onAdClickedCallback: (ad) {},
                onAdExpandedCallback: (ad) {},
                onAdCollapsedCallback: (ad) {}))
        : null,
  );
}

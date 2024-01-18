import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menu_app/custom_widgets/controllers/ad_bar_controller.dart';
import 'package:menu_app/utilities/ad_helper.dart' as ad_helper;
import 'package:provider/provider.dart';
import 'package:menu_app/utilities/constants.dart' as constants;

class AdBar extends StatelessWidget {
  const AdBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdBarController(),
      child: _AdBar(),
    );
  }
}

class _AdBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AdBarController>(context, listen: true);
    if (viewModel.showAd) {
      return Container(
        color: constants.darkThemeColors(context).background,
        alignment: Alignment.topCenter,
        height: viewModel.adHeight,
        child: viewModel.showAd
            ? MaxAdView(
                adUnitId: ad_helper.getAdUnitId,
                adFormat: AdFormat.banner,
                listener: AdViewAdListener(
                  onAdLoadedCallback: (ad) {
                    viewModel.loadAd();
                  },
                  onAdLoadFailedCallback: (adUnitId, error) {
                    viewModel.loadAd();
                  },
                  onAdClickedCallback: (ad) {},
                  onAdExpandedCallback: (ad) {},
                  onAdCollapsedCallback: (ad) {},
                ),
              )
            : null,
      );
    } else {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
  }
}

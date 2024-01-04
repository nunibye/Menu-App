import 'package:applovin_max/applovin_max.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/views/home_page.dart';
import 'package:menu_app/utilities/constants.dart' as constants;
import 'package:menu_app/utilities/ad_helper.dart' as ad_helper;

class RootPage extends StatefulWidget {
  final bool adBool;
  const RootPage({required this.adBool, super.key});
  @override
  State<RootPage> createState() => RootPageState();
}

class RootPageState extends State<RootPage> with WidgetsBindingObserver {
  final scakey = GlobalKey<RootPageState>();

  bool adLoad = false;
  bool showAd = true; //FIXME: CHANGE TO TRUE FOR RELEASE.

  // Indicies of the app pages.
  int selectedIndex = 0;
  int animationms = 150;

  // Changes page based on icon selected [index].
  onItemTapped(int index, int ani) {
    setState(() {
      selectedIndex = index;
      animationms = ani;
    });
    //return 1;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.resumed) {
  //     // Perform version check
  //     bool versionCheckResult = await performVersionCheck();
  //     if (!versionCheckResult) {
  //       showUpdateDialog();
  //     }
  //   }
  // }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (selectedIndex != 0) {
      scakey.currentState?.onItemTapped(0, constants.aniLength);
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  double rh = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: animationms),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
                position: Tween(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation),
                child: child);
          },
          child: const HomePage(adBool: true,),
        ),
      ),
      // TODO: Comment this out to get rid of ad for screenshots!
      // AD bar.
      bottomNavigationBar: Container(
        //color: Colors.amber,
        alignment: Alignment.topCenter,

        height: rh,
        child: widget.adBool
            ? MaxAdView(
                adUnitId: ad_helper.getAdUnitId,
                adFormat: AdFormat.banner,
                listener: AdViewAdListener(
                    onAdLoadedCallback: (ad) {
                      if (ad_helper.getDevice == 'android') {
                        setState(() {
                          rh = 50;
                        });
                      } else if (ad_helper.getDevice == 'ios') {
                        setState(() {
                          rh = 70;
                        });
                      }
                    },
                    onAdLoadFailedCallback: (adUnitId, error) {
                      setState(() {
                        rh = 0;
                      });
                    },
                    onAdClickedCallback: (ad) {},
                    onAdExpandedCallback: (ad) {},
                    onAdCollapsedCallback: (ad) {}))
            : null,
      ),
    );
  }
}

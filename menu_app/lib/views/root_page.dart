import 'package:applovin_max/applovin_max.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menu_app/views/about_page.dart';
import 'package:menu_app/views/calculator.dart';

import 'package:menu_app/views/settings_page.dart';
import 'package:menu_app/views/summary.dart';
import 'package:menu_app/views/hall_page.dart';
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

  late Future futureAlbum;
  late Future nineSummary;
  late Future cowellSummary;
  late Future merrillSummary;
  late Future porterSummary;
  bool adLoad = false;
  bool showAd = true; //FIXME: CHANGE TO TRUE FOR RELEASE.
  //BannerAd? _bannerAd;

  // Indicies of the app pages.
  int selectedIndex = 0;
  int animationms = 150;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MenuPage(name: "Merrill", hasLateNight: false),
    const MenuPage(name: "Cowell", hasLateNight: true),
    const MenuPage(name: "Nine", hasLateNight: true),
    const MenuPage(name: "Porter", hasLateNight: true),
    const MenuPage(name: "Oakes", hasLateNight: true),
    const Calculator(),
    const SettingsPage(),
    const AboutPage(),
  ];

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      scakey.currentState?.onItemTapped(1, 0);
      await Future.delayed(const Duration(milliseconds: 10));
      scakey.currentState?.onItemTapped(0, 0);
    }
  }

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
          child: _widgetOptions.elementAt(selectedIndex),
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

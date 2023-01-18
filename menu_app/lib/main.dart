import 'package:flutter/material.dart';
import 'package:menu_app/home_page.dart';
import 'package:menu_app/settings_page.dart';
import 'constants.dart' as constants;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(constants.darkBlue),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(constants.darkBlue),
        title: const Text(
          "UCSC Menu",
          style: TextStyle(fontSize: 30, color: Color(constants.yellowGold)),
        ),
      ),
      // body: const HomePage(),
      // bottomNavigationBar: NavigationBar(destinations: const [
      //     NavigationDestination(icon: Icon(Icons.food_bank), label: "Menus"),
      //     NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
      //   ],
      //   onDestinationSelected: (int index) {
      //     setState(() {
      //       currentPage = index;
      //     });
      //   },
      //   selectedIndex: currentPage,
      // ),

      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 1000),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.food_bank),
            label: 'Menus',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        backgroundColor: const Color(constants.darkBlue),
        //elevation: 10,
        //surfaceTintColor: Colors.lime,
        //height: 20,
        //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      body: <Widget>[
        Container(
          alignment: Alignment.center,
          child: const HomePage(),
        ),
        Container(
          alignment: Alignment.center,
          child: const SettingsPage(),
        ),
      ][currentPageIndex],
    );
  }
}

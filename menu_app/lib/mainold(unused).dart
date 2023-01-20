import 'package:flutter/material.dart';
import 'package:menu_app/home_page.dart';
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
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color(constants.darkBlue),
        title: const Text(
          "UCSC Menu",
          style: TextStyle(fontSize: 45, fontFamily: 'Monoton', color: Color(constants.yellowGold)),
          
        ),
        shape: const Border(
    bottom: BorderSide(
      color: Colors.orange,
      width: 4
    )
  ),
      ),
      body: const HomePage(),
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

      
    );
  }
}

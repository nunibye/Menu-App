import 'package:flutter/material.dart';
import 'constants.dart' as constants;

class CowellMenu extends StatefulWidget {
  const CowellMenu({super.key});

  @override
  State<CowellMenu> createState() => _CowellMenuState();
}

class _CowellMenuState extends State<CowellMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cowell",
          style: TextStyle(
              fontSize: constants.menuHeadingSize,
              fontFamily: 'Monoton',
              color: Color(constants.yellowGold)),
        ),
        toolbarHeight: 80,
        centerTitle: false,
        backgroundColor: const Color(constants.darkBlue),
        shape: const Border(bottom: BorderSide(color: Colors.orange, width: 4)),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.orange,
            size:constants.backArrowSize
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'constants.dart' as constants;

class MerrillMenu extends StatefulWidget {
  const MerrillMenu({super.key});

  @override
  State<MerrillMenu> createState() => _MerrillMenuState();
}

class _MerrillMenuState extends State<MerrillMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Merrill",
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

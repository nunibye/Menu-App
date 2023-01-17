import 'package:flutter/material.dart';

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
          title: const Text("Cowell Menu"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          )),
    );
  }
}

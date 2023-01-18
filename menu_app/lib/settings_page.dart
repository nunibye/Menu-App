import 'constants.dart' as Constants;
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
      appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 2, 55),
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
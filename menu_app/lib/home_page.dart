import 'package:flutter/material.dart';
import 'package:menu_app/cowell_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double hallSize = MediaQuery.of(context).size.width / 2 - 32;
    return Scaffold(
      // child: ElevatedButton(
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(builder: (BuildContext context) {
      //         return const CowellMenu();
      //       }),
      //     );
      //   },
      //   child: const Text("Cowell"),
      // ),

      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CowellMenu();
                    }),
                  );
                },
                icon: Image.asset('images/cowell_dining_hall.jpg'),
                iconSize: hallSize,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CowellMenu();
                    }),
                  );
                },
                icon: Image.asset('images/cowell_dining_hall.jpg'),
                iconSize: hallSize,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CowellMenu();
                    }),
                  );
                },
                icon: Image.asset('images/cowell_dining_hall.jpg'),
                iconSize: hallSize,
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CowellMenu();
                    }),
                  );
                },
                icon: Image.asset('images/cowell_dining_hall.jpg'),
                iconSize: hallSize,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CowellMenu();
                    }),
                  );
                },
                icon: Image.asset('images/cowell_dining_hall.jpg'),
                iconSize: hallSize,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CowellMenu();
                    }),
                  );
                },
                icon: Image.asset('images/cowell_dining_hall.jpg'),
                iconSize: hallSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

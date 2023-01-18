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
                icon: Image.asset('images/cowell.png'),
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
                icon: Image.asset('images/porter.png'),
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
                icon: Image.asset('images/crown.png'),
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
                icon: Image.asset('images/nine.png'),
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
                icon: Image.asset('images/carson.png'),
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
                icon: Image.asset('images/all.png'),
                iconSize: hallSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

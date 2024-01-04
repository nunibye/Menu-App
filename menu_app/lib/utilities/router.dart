import 'package:go_router/go_router.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/views/about_page.dart';
import 'package:menu_app/views/calculator.dart';
import 'package:menu_app/main.dart';
import 'package:menu_app/views/home_page.dart';
import 'package:menu_app/views/settings_page.dart';
import 'package:menu_app/views/root_page.dart';
import 'package:menu_app/views/hall_page.dart';

// GoRouter configuration
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        name: 'Home',
        path: '/',
        builder: (context, state) {
          // bool adbool = getAdBool() as bool;
          return const HomePage();
        }),
    GoRoute(
      name: 'Merrill',
      path: '/Merrill',
      builder: (context, state) =>
          const MenuPage(name: "Merrill", hasLateNight: false),
    ),
    GoRoute(
      name: 'Cowell',
      path: '/Cowell',
      builder: (context, state) =>
          const MenuPage(name: "Cowell", hasLateNight: true),
    ),
    GoRoute(
      name: 'Nine',
      path: '/Nine',
      builder: (context, state) =>
          const MenuPage(name: "Nine", hasLateNight: true),
    ),
    GoRoute(
      name: 'Porter',
      path: '/Porter',
      builder: (context, state) =>
          const MenuPage(name: "Porter", hasLateNight: true),
    ),
    GoRoute(
      name: 'Oakes',
      path: '/Oakes',
      builder: (context, state) => const MenuPage(
          name: "Oakes", hasLateNight: true), // FIXME change to Carson
    ),
    GoRoute(
      name: 'Calculator',
      path: '/Calculator',
      builder: (context, state) => const Calculator(),
    ),
    GoRoute(
      name: 'Settings',
      path: '/Settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      name: 'About',
      path: '/About',
      builder: (context, state) => const AboutPage(),
    ),
  ],
);

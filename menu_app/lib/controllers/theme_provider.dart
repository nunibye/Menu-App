import 'package:flutter/material.dart';
import 'package:menu_app/utilities/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

ColorScheme _darkThemeColors(
    {required Color primary, required Color secondary}) {
  return ColorScheme(
      brightness: Brightness.dark,
      //
      primary: primary,
      onPrimary: const Color.fromARGB(255, 139, 139, 139),
      //
      secondary: secondary,
      onSecondary: const Color(0xFFEAEAEA),
      // tertiary: Colors.orange,
      error: const Color(0xFFF32424),
      onError: const Color(0xFFF32424),
      surface: const Color(0xff0f0f0f),
      onSecondaryContainer: Colors.black,
      secondaryContainer: Colors.white,
      inverseSurface: const Color.fromARGB(255, 139, 139, 139),

      // onSurface: Color(0xFF202020),
      onSurface: const Color(0xffdbdbdb),
      onSurfaceVariant: const Color(0xFF202020));
}

class ThemeProvider extends ChangeNotifier {
  bool _isDefault = true;
  Color _otherPrimary = constants.defaultPrimary;
  Color _otherSecondary = constants.defaultSecondary;
  ColorScheme _colorScheme = _darkThemeColors(
      primary: constants.defaultPrimary, secondary: constants.defaultSecondary);

  bool get isDefault => _isDefault;
  ColorScheme get colorScheme => _colorScheme;
  
  ThemeProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDefault = prefs.getBool('isDefaultTheme') ?? true;
    _otherPrimary = Color(prefs.getInt('otherPrimaryTheme') ?? 0xFF2098DF);
    _otherSecondary = Color(prefs.getInt('otherSecondaryTheme') ?? 0xFF0004FF);
    _updateTheme();
    notifyListeners();
  }

  void toggleIsDefault(bool value) {
    _isDefault = value;
    _updateTheme();
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDefaultTheme', _isDefault);
    });
  }

  void setPrimary(Color color) {
    _otherPrimary = color;
    _updateTheme();
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('otherPrimaryTheme', color.value);
    });
  }

  void setSecondary(Color color) {
    _otherSecondary = color;
    _updateTheme();
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('otherSecondaryTheme', color.value);
    });
  }

  void _updateTheme() {
    if (_isDefault) {
      _colorScheme = _darkThemeColors(
          primary: constants.defaultPrimary,
          secondary: constants.defaultSecondary);
    } else {
      _colorScheme =
          _darkThemeColors(primary: _otherPrimary, secondary: _otherSecondary);
    }
  }
}

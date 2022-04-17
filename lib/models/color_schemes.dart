// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/settings_controller.dart';

// class ColorChemes {
//   static const Map<String, Map<String, Color>> schemesMap = {
//   'light': {
//     'main': Color.fromARGB(255, 66, 165, 245),
//     'secondary': Color.fromARGB(255, 100, 181, 246),
//     'third': Color.fromARGB(255, 25, 118, 210),
//     'yourtext': Color.fromARGB(255, 21, 101, 192),
//     'otherstext': Color.fromARGB(255, 227, 242, 253),
//     'youranswer': Color.fromARGB(255, 13, 161, 119),
//     'otheranswer': Color.fromARGB(255, 161, 129, 13),
//   },
//   'dark': {
//     'main': Color.fromARGB(255, 0, 40, 85),
//     'secondary': Color.fromARGB(255, 3, 83, 164),
//     'third': Color.fromARGB(255, 4, 102, 200),
//     'yourtext': Color.fromARGB(255, 0, 24, 69),
//     'otherstext': Color.fromARGB(255, 92, 103, 125),
//     'youranswer': Color.fromARGB(255, 13, 161, 119),
//     'otheranswer': Color.fromARGB(255, 161, 129, 13),
//   } };
// }

class ThemeProvider extends ChangeNotifier {
  ThemeMode thememode = Get.find<SettingsController>().getDarkmode()! ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkmode => Get.find<SettingsController>().getDarkmode()!;

  void toggleTheme(bool value) {
    thememode = value ? ThemeMode.dark : ThemeMode.light;
    Get.find<SettingsController>().setDarkmode(value);
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color.fromARGB(255, 220, 193, 111),
    colorScheme: const ColorScheme.light(),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[800],
    primaryColor: Color.fromARGB(255, 220, 193, 111),
    colorScheme: const ColorScheme.dark(),
  );
}
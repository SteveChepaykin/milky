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
    scaffoldBackgroundColor: const Color.fromARGB(255, 132, 200, 255),
    // primaryColor: const Color.fromARGB(255, 220, 193, 111),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 23, 114, 188),
      secondary: Color.fromARGB(255, 36, 127, 202),
      tertiary: Color.fromARGB(255, 44, 97, 211),
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 1, 11, 30),
    // primaryColor: Color.fromARGB(255, 3, 40, 92),
    appBarTheme: const AppBarTheme(backgroundColor: Color.fromARGB(255, 5, 43, 96),),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 90, 151, 197),
      secondary: Color.fromARGB(255, 5, 43, 96),
      tertiary: Color.fromARGB(255, 10, 10, 93),
    ),
  );
}
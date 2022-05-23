// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late double textsize;
  late double bubbleradius;
  late bool isDarkmode;
  late int scheme;
  static const sizekey = 'size';
  static const radkey = 'radius';
  static const darkkey = 'darkmode';
  static const schemekey = 'scheme';

  late final SharedPreferences prefs;

  // SettingsController() {
  //   prefs = SharedPreferences.getInstance();
  // }
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    textsize = getSize()!;
    bubbleradius = getRadius()!;
    isDarkmode = getDarkmode()!;
    scheme = getSchemeIndex()!;
  }

  Future<void> setRadius(double rad) {
    return prefs.setDouble(radkey, rad);
  }

  Future<void> setSize(double size) {
    return prefs.setDouble(sizekey, size);
  }

  Future<void> setDarkmode(bool isdark) {
    return prefs.setBool(darkkey, isdark);
  }

  Future<void> setScheme(int index) {
    return prefs.setInt(schemekey, index);
  }

  double? getSize() {
    return prefs.containsKey(sizekey) ? prefs.getDouble(sizekey) : 16;
  }

  double? getRadius() {
    return prefs.containsKey(radkey) ? prefs.getDouble(radkey) : 12;
  }

  bool? getDarkmode() {
    return prefs.containsKey(darkkey) ? prefs.getBool(darkkey) : false;
  }

  int? getSchemeIndex() {
    return prefs.containsKey(schemekey) ? prefs.getInt(schemekey) : 0;
  }

  // Map<String, Color> colorsMap() {
  //   return getDarkmode()! ? ColorChemes.schemesMap['dark']! : ColorChemes.schemesMap['light']!;
  // }
}
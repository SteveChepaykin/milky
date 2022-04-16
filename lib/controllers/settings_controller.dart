import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late double textsize;
  late double bubbleradius;
  late bool isDarkmode;
  static const sizekey = 'size';
  static const radkey = 'radius';
  static const darkkey = 'darkmode';

  late final SharedPreferences prefs;

  // SettingsController() {
  //   prefs = SharedPreferences.getInstance();
  // }
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    textsize = getSize()!;
    bubbleradius = getRadius()!;
    isDarkmode = getDarkmode()!;
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

  double? getSize() {
    return prefs.containsKey(sizekey) ? prefs.getDouble(sizekey) : 16;
  }

  double? getRadius() {
    return prefs.containsKey(radkey) ? prefs.getDouble(radkey) : 12;
  }

  bool? getDarkmode() {
    return prefs.containsKey(darkkey) ? prefs.getBool(darkkey) : false;
  }
}
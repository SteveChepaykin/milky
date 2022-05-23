// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/settings_controller.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:provider/provider.dart';

class ThemeController extends GetxController {
  // static const schemes = MyThemes.schemes;
  static final schemes = [
    FlexScheme.blue,
    FlexScheme.aquaBlue,
    FlexScheme.mango,
    FlexScheme.money,
  ];

  var themes$ = <ThemeData>[].obs;

  Rx<ThemeMode> thememode$ = (Get.find<SettingsController>().getDarkmode()! ? ThemeMode.dark : ThemeMode.light).obs;
  // FlexScheme scheme = schemes[Get.find<SettingsController>().getSchemeIndex()!];
  RxInt ind$ = (Get.find<SettingsController>().getSchemeIndex()!).obs;

  // Rx<bool> get isDarkmode => (thememode$.value == ThemeMode.dark).obs;

  void init() {
    themes$.value = [
      MyThemes.lightTheme,
      MyThemes.darkTheme,
    ];
  }

  void toggleTheme(bool value) {
    thememode$.value = value ? ThemeMode.dark : ThemeMode.light;
    Get.find<SettingsController>().setDarkmode(value);
  }

  void chooseScheme(int index) {
    // scheme = schemes[index];
    ind$.value = index;
    Get.find<SettingsController>().setScheme(index);
    themes$.value = [
      MyThemes.lightTheme,
      MyThemes.darkTheme,
    ];
    // scheme = schemes[Get.find<SettingsController>().getSchemeIndex()!];
  }
}

class MyThemes {
  static const schemes = [
    FlexScheme.blue,
    FlexScheme.aquaBlue,
    FlexScheme.mango,
    FlexScheme.money,
  ];

  static ThemeData get lightTheme => FlexThemeData.light(
    scheme: schemes[Get.find<SettingsController>().getSchemeIndex()!],
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    appBarOpacity: 0.90,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 30,
      blendOnColors: false,
      toggleButtonsRadius: 13.0,
      unselectedToggleIsColored: true,
      inputDecoratorRadius: 16.0,
      fabRadius: 13.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  static ThemeData get darkTheme => FlexThemeData.dark(
    scheme: schemes[Get.find<SettingsController>().getSchemeIndex()!],
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 20,
    appBarOpacity: 0.90,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 30,
      toggleButtonsRadius: 13.0,
      unselectedToggleIsColored: true,
      inputDecoratorRadius: 16.0,
      fabRadius: 13.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}

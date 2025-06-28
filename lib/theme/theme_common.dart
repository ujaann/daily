import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      scaffoldBackgroundColor: ColorsDaily.white,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorsDaily.green,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStateTextStyle.resolveWith(
          (_) => TextStyle(color: Colors.white),
        ),
        indicatorColor: ColorsDaily.purple,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ColorsDaily.purple, shape: CircleBorder()),
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsDaily.green,
        shadowColor: ColorsDaily.green,
        elevation: 4,
        titleTextStyle: FontsDaily.bigTitle,
      ),
      textTheme: Typography.material2021().englishLike.apply(
          displayColor: ColorsDaily.black, bodyColor: ColorsDaily.darkgray),
      inputDecorationTheme: InputDecorationTheme(
        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorsDaily.darkgray,
            width: 1,
          ),
        ),

        // Active (enabled) border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorsDaily.green,
            width: 1,
          ),
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorsDaily.purple,
            width: 2,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: ColorsDaily.darkgray, width: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorsDaily.purple,
            foregroundColor: ColorsDaily.white),
      ));
}

abstract final class FontsDaily {
  static const bigHeadline = TextStyle(fontSize: 32);
  static const bigTitle = TextStyle(fontSize: 22);
  static const titleSubText = TextStyle(fontSize: 16);
  static const subText = TextStyle();
  static const normal = TextStyle();
  static const small = TextStyle();
  static const medium = TextStyle();
}

// Colors from
// https://coolors.co/eee5d0-faf8f2-69afaf-3a5c5c-612091-422a62-223332-0a0908
abstract final class ColorsDaily {
  static const cream = Color(0xffEEE5D0);
  static const cream70 = Color(0xb3EEE5D0);
  static const white = Color(0xffFAF8F2);
  static const white70 = Color(0xb3FAF8F2);
  static const green = Color(0xff69afaf);
  static const purple = Color(0xff612091);
  static const darkgray = Color(0xff3a5c5c);
  static const black = Color(0xff18121f);
}

import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

class Clock365Theme {
  static ThemeData getThemeData(ThemeData baseTheme,
          {bool isDarkTheme = false}) =>
      !isDarkTheme
          ? baseTheme.copyWith(
              appBarTheme: AppBarTheme(
                  brightness: !isDarkTheme ? Brightness.light : Brightness.dark,
                  elevation: 0,
                  backgroundColor: primaryColor),
              colorScheme: baseTheme.colorScheme
                  .copyWith(primary: primaryColor, secondary: secondaryColor),
              checkboxTheme: baseTheme.checkboxTheme
                  .copyWith(fillColor: MaterialStateProperty.all(primaryColor)),
              inputDecorationTheme: InputDecorationTheme(
                  focusColor: baseTheme.scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2, color: primaryColor))),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 24),
                textStyle: textTheme.button,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              )))
          : baseTheme.copyWith();
}

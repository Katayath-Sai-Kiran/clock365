
import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

class ColorState extends ChangeNotifier {
  Color? pColor;
  double? intensity;
  ColorState({required this.pColor, required this.intensity});
}

class Clock365Theme extends ColorState {
  Clock365Theme({
    @required Color? pColor,
    @required double? intensity,
  }) : super(pColor: pColor, intensity: intensity);

  static ThemeData getThemeData(
    ThemeData baseTheme, {
    bool isDarkTheme = false,
    required Color pColor,
    required double intensity,
  }) =>
      !isDarkTheme
          ? baseTheme.copyWith(
              appBarTheme: AppBarTheme(
                brightness: !isDarkTheme ? Brightness.light : Brightness.dark,
                elevation: 0,
                backgroundColor: pColor.withOpacity(intensity),
              ),
              colorScheme: baseTheme.colorScheme.copyWith(
                primary: pColor.withOpacity(intensity),
                secondary: secondaryColor,
              ),
              checkboxTheme: baseTheme.checkboxTheme.copyWith(
                  fillColor:
                      MaterialStateProperty.all(pColor.withOpacity(intensity))),
              inputDecorationTheme: InputDecorationTheme(
                  focusColor: baseTheme.scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          width: 2, color: pColor.withOpacity(intensity)))),
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

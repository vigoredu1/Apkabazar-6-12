import 'package:flutter/material.dart';
import 'package:quickad_it_solutions/util/app_constants.dart';

ThemeData dark({Color color = const Color(0xFFFF0000)}) => ThemeData(
      fontFamily: AppConstants.fontFamily,
      primaryColor: color,
      secondaryHeaderColor: const Color(0xFFFF0000),
      disabledColor: const Color(0xffa2a7ad),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: const Color(0xFF30313C),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.dark(primary: color, secondary: color)
          .copyWith(background: const Color(0xFF191A26))
          .copyWith(error: const Color(0xFFdd3135)),
    );

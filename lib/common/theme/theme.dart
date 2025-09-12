import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white54),
  useMaterial3: true,
  scaffoldBackgroundColor: Color.fromARGB(255, 30, 31, 36),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 255, 211, 140),
    ),
    backgroundColor: const Color.fromARGB(255, 49, 59, 84),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: Color.fromARGB(255, 255, 211, 140),
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Color.fromARGB(255, 75, 160, 255),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: Colors.white.withValues(alpha: 0.8),
      fontSize: 16,
    ),
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStateProperty.all(
      const Color.fromARGB(255, 59, 69, 94),
    ),
    overlayColor: WidgetStatePropertyAll(
      const Color.fromARGB(255, 69, 79, 104),
    ),
    textStyle: WidgetStatePropertyAll(
      TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
    ),
  ),
);

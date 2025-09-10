import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Color.fromARGB(255, 30, 31, 36),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    foregroundColor: Color.fromARGB(255, 255, 255, 255),
    backgroundColor: Color.fromARGB(255, 57, 60, 70),
  ),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: Color.fromARGB(255, 78, 161, 255),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
    ),
  ),
);

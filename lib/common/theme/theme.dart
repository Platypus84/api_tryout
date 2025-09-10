import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Color.fromARGB(255, 43, 44, 47),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    foregroundColor: Color.fromARGB(255, 255, 255, 255),
    backgroundColor: Color.fromARGB(255, 43, 44, 47),
  ),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: Color.fromARGB(255, 78, 202, 255),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
    ),
  ),
);

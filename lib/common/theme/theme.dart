import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Color.fromARGB(255, 43, 44, 47),
  appBarTheme: AppBarTheme(
    foregroundColor: Color.fromARGB(255, 255, 255, 255),
    backgroundColor: Color.fromARGB(255, 43, 44, 47),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
    ),
  ),
);

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightBlue.shade400, brightness: Brightness.light),
  primaryColor: Colors.blue.shade700,
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightBlue.shade600, brightness: Brightness.dark),
  primaryColor: const Color.fromARGB(255, 44, 89, 110),
);

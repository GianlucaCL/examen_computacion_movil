
import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary = Color.fromARGB(255, 33, 150, 243);  // Azul claro

  static final ThemeData myTheme = ThemeData(
    primaryColor: Color.fromARGB(255, 25, 118, 210),  // Azul oscuro
    brightness: Brightness.light,
    fontFamily: 'Raleway',
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 30, 136, 229),  // Azul intermedio
      elevation: 10,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
    ),
  );
}

import "package:flutter/material.dart";

/// Provides [ThemeData] for application User Interface, typography and custom
/// buttons in both light and dark variant.
class ThemeProvider {
  static final lightTheme = ThemeData(
      textButtonTheme: TextButtonThemeData(
          style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        primary: const Color.fromRGBO(158, 42, 43, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      )),
      indicatorColor: const Color.fromRGBO(158, 42, 43, 1),
      brightness: Brightness.light,
      primaryColor: const Color.fromRGBO(158, 42, 43, 1),
      colorScheme: const ColorScheme.light(
        primary: Color.fromRGBO(158, 42, 43, 1),
        primaryVariant: Colors.green,
        secondary: Colors.orange,
        onSurface: Colors.black,
        secondaryVariant: Colors.grey,
        onBackground: Color.fromRGBO(158, 42, 43, 1),
      ),
      textTheme: const TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color.fromRGBO(158, 42, 43, 1),
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color.fromRGBO(158, 42, 43, 1),
          ),
          bodyText1: TextStyle(
            fontSize: 15,
          ),
          caption: TextStyle(fontSize: 13, color: Colors.grey)));

  static final darkTheme = ThemeData(
      textButtonTheme: TextButtonThemeData(
          style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        primary: const Color.fromRGBO(186, 51, 51, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      )),
      indicatorColor: const Color.fromRGBO(186, 51, 51, 1),
      brightness: Brightness.dark,
      primaryColor: const Color.fromRGBO(158, 42, 43, 1),
      colorScheme: const ColorScheme.dark(
        primary: Color.fromRGBO(186, 51, 51, 1),
        primaryVariant: Colors.white,
        onSurface: Colors.white,
        secondary: Colors.orange,
        secondaryVariant: Colors.white,
        onBackground: Colors.grey,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.orange,
      ),
      textTheme: const TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color.fromRGBO(186, 51, 51, 1),
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color.fromRGBO(186, 51, 51, 1),
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.orange,
          ),
          bodyText1: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          caption: TextStyle(fontSize: 13, color: Colors.grey)));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static var lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      disabledColor: Colors.grey.shade300,
      cardColor: Colors.red.shade800,
      canvasColor: Colors.white,
      backgroundColor: Colors.grey.shade200,
      scaffoldBackgroundColor: Colors.grey.shade200,
      dividerColor: Colors.grey.shade400,
      primarySwatch: Colors.red,
      secondaryHeaderColor: const Color(0xFFE24343),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Colors.red.shade800),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white, // text on button
          primary: Colors.red.shade800, // button color
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0x80803F44),
      ));
  static var darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey.shade50,
    disabledColor: Colors.grey.shade900,
    cardColor: Colors.red.shade300,
    canvasColor: Colors.grey.shade800,
    backgroundColor: const Color(0xff2f3437),
    scaffoldBackgroundColor: const Color(0xff2f3437),
    dividerColor: Colors.grey.shade600,
    primarySwatch: Colors.red,
    secondaryHeaderColor: const Color(0xFFB65D5D),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.red.shade300),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.grey.shade50, // text on button
        primary: Colors.red.shade300, // button color
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey.shade50),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade50,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0x80803F44),
    ),
  );
}

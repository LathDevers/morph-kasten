import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morph_kasten/home_page.dart';
import 'package:morph_kasten/theme_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MorphKastenApp());
}

class MorphKastenApp extends StatelessWidget {
  const MorphKastenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BI-Vital',
      home: const MyHomePage(),
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

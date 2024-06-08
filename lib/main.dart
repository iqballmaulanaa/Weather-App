import 'package:flutter/material.dart';
import 'package:weather_app/homescreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    theme: ThemeData(
      primaryColor: Colors.white,
      colorScheme:
          ColorScheme.light(primary: Colors.white, secondary: Colors.white),
    ),
  ));
}

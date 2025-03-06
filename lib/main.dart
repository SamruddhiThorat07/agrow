import 'package:flutter/material.dart';
import 'screens/weather_screen.dart'; // Import the WeatherScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmAssist',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherScreen(), // Set WeatherScreen as the home screen
      debugShowCheckedModeBanner: false, // Optional: Removes debug banner
    );
  }
}
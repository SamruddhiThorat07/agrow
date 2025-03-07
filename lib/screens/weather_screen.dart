import 'package:flutter/material.dart';
import '../utils/color_schemes.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorSchemes.weather['primary']!,
              AppColorSchemes.weather['secondary']!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.blue[700],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Weather',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Pune, Maharashtra',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.cloud, color: Colors.white),
                                Text('Now', style: TextStyle(color: Colors.white)),
                                Text('32°C', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.cloud, color: Colors.white),
                                Text('11 AM', style: TextStyle(color: Colors.white)),
                                Text('33°C', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.wb_sunny, color: Colors.white),
                                Text('1 PM', style: TextStyle(color: Colors.white)),
                                Text('35°C', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.wb_sunny, color: Colors.white),
                                Text('3 PM', style: TextStyle(color: Colors.white)),
                                Text('34°C', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.cloud, color: Colors.white),
                                Text('5 PM', style: TextStyle(color: Colors.white)),
                                Text('31°C', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red[700]),
                              SizedBox(width: 8),
                              Text(
                                'Thunderstorm warning: Secure crops by 4 PM',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Add more sections (e.g., My Land Profiles) below if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
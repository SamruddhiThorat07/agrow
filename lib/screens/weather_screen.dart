import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Heading part: Title and language switch
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FarmAssist',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(width: 8), // Spacing between title and language
            DropdownButton<String>(
              items: <String>['English', 'Hindi', 'Marathi'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {}, // Placeholder, implement language switch logic
              icon: Icon(Icons.language, color: Colors.grey),
              underline: SizedBox(),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
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
    );
  }
}
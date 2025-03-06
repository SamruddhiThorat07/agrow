import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agrow/main.dart'; // Adjust the import based on your project name

void main() {
  testWidgets('WeatherScreen loads successfully', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify that the WeatherScreen title is present
    expect(find.text('FarmAssist'), findsOneWidget);

    // Verify that the weather card is present
    expect(find.text('Today\'s Weather'), findsOneWidget);
    expect(find.text('Pune, Maharashtra'), findsOneWidget);
    expect(find.text('32°C'), findsOneWidget); // Check for a temperature
  });
}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String apiKey = "91b6ee19f64448a8b3c90143250703";
  static const String baseUrl = "http://api.weatherapi.com/v1";

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> getWeatherData(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
        '$baseUrl/current.json?key=$apiKey&q=$latitude,$longitude&aqi=yes'
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'location': data['location']['name'],
          'temperature': data['current']['temp_c'].round(),
          'condition': data['current']['condition']['text'],
          'description': data['current']['condition']['text'],
          'humidity': data['current']['humidity'],
          'windSpeed': data['current']['wind_kph'].round(),
          'pressure': data['current']['pressure_mb'],
          'feelsLike': data['current']['feelslike_c'].round(),
          'icon': data['current']['condition']['icon'],
          'airQuality': data['current']['air_quality']['us-epa-index'],
          'uv': data['current']['uv'],
          'lastUpdated': data['current']['last_updated'],
        };
      } else {
        throw 'Failed to load weather data';
      }
    } catch (e) {
      throw 'Error getting weather data: $e';
    }
  }

  Future<Map<String, dynamic>> getForecastData(double latitude, double longitude, {int days = 3}) async {
    try {
      final response = await http.get(Uri.parse(
        '$baseUrl/forecast.json?key=$apiKey&q=$latitude,$longitude&days=$days&aqi=yes'
      ));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw 'Failed to load forecast data';
      }
    } catch (e) {
      throw 'Error getting forecast data: $e';
    }
  }
} 
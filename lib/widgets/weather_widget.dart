import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';
import '../utils/weather_icons.dart';

class WeatherWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onWeatherDataUpdate;

  const WeatherWidget({
    Key? key, 
    required this.onWeatherDataUpdate,
  }) : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? forecastData;
  Position? position;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      setState(() => isLoading = true);
      position = await _weatherService.getCurrentLocation();
      if (position != null) {
        weatherData = await _weatherService.getWeatherData(
          position!.latitude,
          position!.longitude,
        );
        forecastData = await _weatherService.getForecastData(
          position!.latitude,
          position!.longitude,
        );
        if (weatherData != null && forecastData != null) {
          widget.onWeatherDataUpdate({
            ...weatherData!,
            'forecast': forecastData!['forecast'],
          });
        }
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildWeatherDetail(String title, String value, IconData icon, {Color? iconColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? Color(0xFF8BC34A), size: 22),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[850],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getUVDescription(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  Color _getUVColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  Widget _buildForecastDay(Map<String, dynamic> day) {
    final date = DateTime.parse(day['date']);
    final dayName = DateFormat('EEE').format(date);
    final condition = day['day']['condition']['text'];
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF8BC34A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              WeatherIcons.getWeatherIcon(condition).toString(),
              style: TextStyle(fontSize: 32),
            ),
          ),
          SizedBox(height: 8),
          Text(
            condition,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward, color: Colors.red[400], size: 16),
              Text(
                '${day['day']['maxtemp_c'].round()}°',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_downward, color: Colors.blue[400], size: 16),
              Text(
                '${day['day']['mintemp_c'].round()}°',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[400],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop, color: Colors.blue[300], size: 14),
              SizedBox(width: 4),
              Text(
                '${day['day']['daily_chance_of_rain']}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Card(
          elevation: 4,
          child: Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF8BC34A)),
                  SizedBox(height: 16),
                  Text('Loading weather data...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error: $error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (weatherData == null || forecastData == null) {
      return Center(
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text('No weather data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final forecast = forecastData!['forecast']['forecastday'] as List;

    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8BC34A).withOpacity(0.9),
                Color(0xFF8BC34A).withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location and Time
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text(
                      weatherData!['location'] ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // Current Weather and Temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WeatherIcons.getWeatherColor(
                        weatherData!['condition'] ?? ''
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: WeatherIcons.getWeatherIcon(
                      weatherData!['condition'] ?? '',
                      size: 56,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weatherData!['temperature']}°',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'C',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        weatherData!['condition'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Weather Details
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildWeatherDetail(
                    'Humidity',
                    '${weatherData!['humidity']}%',
                    Icons.water_drop,
                    iconColor: Colors.blue[300],
                  ),
                  _buildWeatherDetail(
                    'Wind',
                    '${weatherData!['windSpeed']} km/h',
                    Icons.air,
                    iconColor: Colors.cyan,
                  ),
                  _buildWeatherDetail(
                    'UV',
                    '${weatherData!['uv']}',
                    Icons.wb_sunny,
                    iconColor: _getUVColor(weatherData!['uv']),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
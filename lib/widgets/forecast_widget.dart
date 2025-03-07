import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/weather_icons.dart';

class ForecastWidget extends StatelessWidget {
  final List<dynamic> forecast;

  const ForecastWidget({Key? key, required this.forecast}) : super(key: key);

  Widget _buildForecastDay(Map<String, dynamic> day) {
    final date = DateTime.parse(day['date']);
    final dayName = DateFormat('EEE').format(date);
    final condition = day['day']['condition']['text'];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: WeatherIcons.getWeatherColor(condition).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: WeatherIcons.getWeatherIcon(condition, size: 24),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day['day']['maxtemp_c'].round()}°',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              Text(' / '),
              Text(
                '${day['day']['mintemp_c'].round()}°',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[400],
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Color(0xFF8BC34A)),
                SizedBox(width: 8),
                Text(
                  '3-Day Forecast',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: forecast.map((day) => 
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: _buildForecastDay(day),
                  ),
                )
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 
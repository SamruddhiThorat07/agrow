import 'package:flutter/material.dart';

class WeatherIcons {
  static Widget getWeatherIcon(String condition, {double size = 24}) {
    IconData iconData;
    Color iconColor;
    
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        iconData = Icons.wb_sunny_rounded;
        iconColor = Colors.amber;
        return Icon(
          iconData,
          size: size,
          color: iconColor,
        );
      case 'partly cloudy':
        iconData = Icons.cloud_queue_rounded;
        iconColor = Colors.lightBlue;
        break;
      case 'cloudy':
      case 'overcast':
        iconData = Icons.cloud_rounded;
        iconColor = Colors.grey;
        break;
      case 'mist':
      case 'fog':
        iconData = Icons.cloud_rounded;
        iconColor = Colors.blueGrey;
        break;
      case 'light rain':
      case 'patchy rain':
        iconData = Icons.grain_rounded;
        iconColor = Colors.blue[300]!;
        break;
      case 'rain':
        iconData = Icons.water_drop_rounded;
        iconColor = Colors.blue;
        break;
      case 'heavy rain':
        iconData = Icons.thunderstorm_rounded;
        iconColor = Colors.indigo;
        break;
      case 'snow':
        iconData = Icons.ac_unit_rounded;
        iconColor = Colors.lightBlue[100]!;
        break;
      case 'thunder':
        iconData = Icons.flash_on_rounded;
        iconColor = Colors.orange;
        break;
      case 'sunny intervals':
        iconData = Icons.wb_cloudy_rounded;
        iconColor = Colors.orange;
        break;
      case 'clear night':
        iconData = Icons.nightlight_round;
        iconColor = Colors.indigo[300]!;
        break;
      default:
        iconData = Icons.cloud_queue_rounded;
        iconColor = Colors.grey[400]!;
        break;
    }

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        size: size,
        color: iconColor,
      ),
    );
  }

  static Color getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Colors.transparent;
      case 'partly cloudy':
        return Colors.lightBlue;
      case 'cloudy':
      case 'overcast':
        return Colors.grey;
      case 'rain':
      case 'light rain':
      case 'patchy rain':
        return Colors.blue;
      case 'heavy rain':
      case 'thunder':
        return Colors.indigo;
      case 'snow':
        return Colors.lightBlue[100]!;
      case 'clear night':
        return Colors.indigo[300]!;
      default:
        return Colors.grey[400]!;
    }
  }
} 
import 'package:flutter/material.dart';
import 'subsidies_screen.dart';
import 'consultation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'crop_advisory_screen.dart';
import 'crop_disease_screen.dart';

// Update mock data with weather-specific icons and more time slots
Map<String, dynamic> mockWeatherData = {
  "location": "Mumbai",
  "temperature": 30,
  "condition": "Partly Cloudy",
  "icon": Icons.cloud,
  "warnings": "warningMessage",
  "forecast": [
    {"time": "3 AM", "temp": 26, "icon": Icons.nights_stay},         // Night
    {"time": "6 AM", "temp": 28, "icon": Icons.cloud_queue},         // Dawn
    {"time": "9 AM", "temp": 30, "icon": Icons.wb_sunny},            // Morning
    {"time": "12 PM", "temp": 32, "icon": Icons.thunderstorm},       // Noon
    {"time": "3 PM", "temp": 31, "icon": Icons.wb_sunny},            // Afternoon
    {"time": "6 PM", "temp": 29, "icon": Icons.water_drop},          // Evening
    {"time": "9 PM", "temp": 27, "icon": Icons.nights_stay},         // Night
  ]
};

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;  // Add this

  const HomeScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color weatherBlue = Color(0xFF2196F3);  // Vibrant blue
  static const Color lightGreen = Color(0xFF8BC34A);   // Light green for theme
  
  String currentLanguage = 'English';  // Default language
  
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'हिंदी', 'code': 'hi'},    // Hindi
    {'name': 'मराठी', 'code': 'mr'},    // Marathi
  ];

  void _changeLanguage(String? langCode) {
    if (langCode != null) {
      setState(() {
        currentLanguage = languages.firstWhere((lang) => lang['code'] == langCode)['name']!;
      });
      // Use the callback to change locale
      widget.onLocaleChange(Locale(langCode));
    }
  }

  // Get warning level and icon based on message
  Map<String, dynamic> getWarningLevel(String warning, AppLocalizations localizations) {
    if (warning.isEmpty) {
      return {
        "level": localizations.safe,
        "icon": Icons.check_circle,
        "color": lightGreen
      };
    } else if (warning.toLowerCase().contains("alert")) {
      return {
        "level": localizations.caution,
        "icon": Icons.warning,
        "color": const Color(0xFFB3A000)
      };
    } else {
      return {
        "level": localizations.danger,
        "icon": Icons.error,
        "color": Colors.red
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final warningInfo = getWarningLevel(mockWeatherData['warnings'], appLocalizations);
    final currentTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,  // Center the title
        title: Row(
          mainAxisSize: MainAxisSize.min,  // This makes the Row take minimum space
          children: [
            Icon(Icons.eco, size: 24),  // Leaf icon
            SizedBox(width: 8),
            Text(
              appLocalizations.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: lightGreen,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              dropdownColor: lightGreen,
              icon: Icon(Icons.language, color: Colors.white),
              underline: Container(),  // Removes the default underline
              value: languages.firstWhere((lang) => lang['name'] == currentLanguage)['code'],
              items: languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language['code'],
                  child: Text(
                    language['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _changeLanguage,
            ),
          ),
        ],
      ),
      backgroundColor: lightGreen.withOpacity(0.1),  // Light green background for the whole app
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather Info Box
              Card(
                elevation: 2,  // Lighter shadow
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: weatherBlue.withOpacity(0.1)),
                    color: weatherBlue.withOpacity(0.05),  // Light blue background
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.todaysWeather,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appLocalizations.location,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  appLocalizations.temperature(
                                    mockWeatherData['temperature']
                                  ),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  mockWeatherData['icon'],
                                  size: 32,
                                  color: weatherBlue,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  appLocalizations.condition,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          appLocalizations.currentTime(
                            '${currentTime.hour}:${currentTime.minute}'
                          ),
                          style: TextStyle(color: const Color(0xFF9E9E9E)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Hourly Forecast
              Text(
                appLocalizations.hourlyForecast,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: (mockWeatherData['forecast'] as List).map((forecast) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            appLocalizations.timeFormat(
                              int.parse(forecast['time'].split(' ')[0]),
                              forecast['time'].contains('AM') ? 
                                appLocalizations.am : appLocalizations.pm
                            ),
                          ),
                          SizedBox(height: 4),
                          Icon(
                            forecast['icon'],
                            size: 24,
                            color: weatherBlue,
                          ),
                          SizedBox(height: 4),
                          Text(
                            appLocalizations.forecastTemp(forecast['temp']),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 16),

              // Weather Warnings
              if (mockWeatherData['warnings'].isNotEmpty)
                Card(
                  elevation: 2,  // Lighter shadow
                  color: warningInfo['color'].withOpacity(0.05),  // Much lighter background
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: warningInfo['color'].withOpacity(0.2)),  // Subtle border
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            warningInfo['icon'],
                            size: 24,
                            color: warningInfo['color'].withOpacity(0.8),  // Slightly softer icon
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              appLocalizations.warningMessage,
                              style: TextStyle(
                                color: warningInfo['color'].withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 16),

              // Add this new Crop Advisory Card
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CropAdvisoryScreen()),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.eco,
                              size: 24,
                              color: lightGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              appLocalizations.cropAdvisory,  // Add this to your localizations
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          appLocalizations.cropAdvisoryDesc,  // Add this to your localizations
                          style: TextStyle(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Add this new Crop Disease Card
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CropDiseaseScreen()),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.healing,
                              size: 24,
                              color: lightGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              appLocalizations.cropDisease,  // Add to localizations
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          appLocalizations.cropDiseaseDesc,  // Add to localizations
                          style: TextStyle(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Government Subsidies and Schemes
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubsidiesScreen()),
                  );
                },
                child: Card(
                  elevation: 2,  // Lighter shadow
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.policy,
                              size: 24,
                              color: lightGreen,  // Update to theme color
                            ),
                            SizedBox(width: 8),
                            Text(
                              appLocalizations.govtSchemes,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          appLocalizations.govtSchemesDesc,
                          style: TextStyle(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Expert Consultation
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsultationScreen()),
                  );
                },
                child: Card(
                  elevation: 2,  // Lighter shadow
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.support_agent,
                              size: 24,
                              color: lightGreen,  // Update to theme color
                            ),
                            SizedBox(width: 8),
                            Text(
                              appLocalizations.expertConsultation,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          appLocalizations.expertConsultationDesc,
                          style: TextStyle(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

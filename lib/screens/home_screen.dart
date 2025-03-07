import 'package:flutter/material.dart';
import 'subsidies_screen.dart';
import 'consultation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'crop_advisory_screen.dart';
import 'crop_disease_screen.dart';
import 'pesticide_screen.dart';

// Update mock data with weather-specific icons and more time slots
Map<String, dynamic> mockWeatherData = {
  "location": "Mumbai",
  "temperature": 30,
  "condition": "Partly Cloudy",
  "icon": Icons.cloud,
  "warnings": "warningMessage",
  "forecast": [
    {"time": "03:00", "temp": 26, "icon": Icons.nights_stay},
    {"time": "06:00", "temp": 28, "icon": Icons.cloud_queue},
    {"time": "09:00", "temp": 30, "icon": Icons.wb_sunny},
    {"time": "12:00", "temp": 32, "icon": Icons.thunderstorm},
    {"time": "15:00", "temp": 31, "icon": Icons.wb_sunny},
    {"time": "18:00", "temp": 29, "icon": Icons.water_drop},
    {"time": "21:00", "temp": 27, "icon": Icons.nights_stay},
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
              // Weather Info Box with improved UI
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        weatherBlue.withOpacity(0.05),
                        weatherBlue.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocalizations.todaysWeather,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(
                              mockWeatherData['icon'],
                              size: 36,
                              color: weatherBlue,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appLocalizations.location,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  appLocalizations.temperature(
                                    mockWeatherData['temperature']
                                  ),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: weatherBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                appLocalizations.condition,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: weatherBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Hourly Forecast with horizontal scroll
              Text(
                appLocalizations.hourlyForecast,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: mockWeatherData['forecast'].length,
                    itemBuilder: (context, index) {
                      final forecast = mockWeatherData['forecast'][index];
                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        width: 80,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  forecast['time'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Icon(
                                  forecast['icon'],
                                  size: 24,
                                  color: weatherBlue,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${forecast['temp']}°',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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

              // Pesticide Advisory Feature Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PesticideScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.pest_control,
                              color: Color(0xFF8BC34A),
                              size: 32,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Pesticide Advisory',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Get personalized recommendations for pest control based on your crop and region',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF8BC34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

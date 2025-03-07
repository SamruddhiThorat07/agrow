import 'package:flutter/material.dart';
import 'subsidies_screen.dart';
import 'consultation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'crop_advisory_screen.dart';
import 'crop_disease_screen.dart';
import 'weather_screen.dart';
import 'market_screen.dart';
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

  const HomeScreen({super.key, required this.onLocaleChange});

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

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: backgroundColor,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

              SizedBox(height: 24),

              // Grid of feature cards
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildFeatureCard(
                    title: appLocalizations.cropDisease,
                    icon: Icons.healing,
                    backgroundColor: Colors.amber,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CropDiseaseScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    title: appLocalizations.cropAdvisory,
                    icon: Icons.eco,
                    backgroundColor: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CropAdvisoryScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    title: appLocalizations.govtSchemes,
                    icon: Icons.policy,
                    backgroundColor: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubsidiesScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    title: appLocalizations.expertConsultation,
                    icon: Icons.support_agent,
                    backgroundColor: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConsultationScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    title: 'Pesticide Advisory',
                    icon: Icons.pest_control,
                    backgroundColor: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PesticideScreen()),
                    ),
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

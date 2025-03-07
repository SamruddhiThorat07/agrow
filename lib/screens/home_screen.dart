import 'package:flutter/material.dart';
import 'subsidies_screen.dart';
import 'consultation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'crop_advisory_screen.dart';
import 'crop_disease_screen.dart';
import 'weather_screen.dart';
import 'market_screen.dart';
import 'pesticide_screen.dart';
import '../widgets/weather_widget.dart';
import '../widgets/forecast_widget.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../utils/color_schemes.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomeScreen({super.key, required this.onLocaleChange});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color lightGreen = Color(0xFF8BC34A);   // Light green for theme
  
  String currentLanguage = 'English';  // Default language
  Map<String, dynamic>? weatherData; // Add this line
  
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'हिंदी', 'code': 'hi'},    // Hindi
    {'name': 'मराठी', 'code': 'mr'},    // Marathi
  ];

  void _changeLanguage(String? langCode) {
    if (langCode != null) {
      setState(() {
        currentLanguage = languages.firstWhere((lang) => lang['code'] == langCode)['name']!;
      });
      widget.onLocaleChange(Locale(langCode));
    }
  }

  // Add this method to update weather data
  void updateWeatherData(Map<String, dynamic> data) {
    setState(() {
      weatherData = data;
    });
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorSchemes.home['primary']!,
              AppColorSchemes.home['secondary']!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Weather Widget with callback
                WeatherWidget(onWeatherDataUpdate: updateWeatherData),
                SizedBox(height: 16),

                // Forecast Widget (only show if weather data is available)
                if (weatherData != null && weatherData!['forecast'] != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ForecastWidget(
                      forecast: weatherData!['forecast']['forecastday'],
                    ),
                  ),
                SizedBox(height: 16),
                
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
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
                          _buildFeatureCard(
                            title: 'Market Prices',
                            icon: Icons.trending_up,
                            backgroundColor: Colors.deepPurple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => MarketProvider(),
                                  child: MarketScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add this custom clipper class
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/color_schemes.dart';

class CropAdvisoryScreen extends StatefulWidget {
  const CropAdvisoryScreen({super.key});

  @override
  _CropAdvisoryScreenState createState() => _CropAdvisoryScreenState();
}

class _CropAdvisoryScreenState extends State<CropAdvisoryScreen> {
  String? selectedCropMethod;
  String? selectedCrop;
  String? selectedIrrigationMethodType;
  String? selectedIrrigationMethod;
  String? selectedWeatherMethodType;
  String? selectedWeather;
  TextEditingController areaController = TextEditingController();
  String soilType = "Loam"; // Default value

  final List<String> crops = [
    "wheat", "rice", "cotton", "sugarcane", "maize",
    "soybean", "potato", "tomato", "onion", "groundnut",
    "chickpea", "mustard", "sunflower", "turmeric", "ginger",
    "garlic", "chili", "cauliflower", "cabbage", "carrot",
    "peas", "beans", "cucumber", "eggplant", "okra"
  ];

  final List<String> irrigationMethods = [
    "drip", "sprinkler", "flood", "furrow", "centerPivot",
    "subsurfaceDrip", "microSprinkler", "surface", "basin", "borderStrip"
  ];

  final List<String> weatherConditions = [
    "sunny", "partlyCloudy", "overcast", "lightRain", "heavyRain",
    "thunderstorm", "windy", "hotHumid", "coldDry", "foggy",
    "hazy", "drought", "highTemp", "lowTemp"
  ];

  final List<String> areaUnits = [
    "acres", "hectares", "squareMeters", "squareFeet", "guntha", "bigha"
  ];

  String selectedAreaUnit = "acres";

  String? aiResponse;
  bool isLoading = false;
  final String apiKey = "AIzaSyAqnSFAI1M5ceD51u8FnBOsbFCfwuuCJn4";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent";

  @override
  void initState() {
    super.initState();
    // Set default values
    selectedCropMethod = 'list';
    selectedIrrigationMethodType = 'list';
    selectedWeatherMethodType = 'list';
  }

  bool isFormValid() {
    print('Checking form validity:');
    print('Crop Method: $selectedCropMethod, Crop: $selectedCrop');
    print('Area: ${areaController.text}');
    print('Irrigation Method Type: $selectedIrrigationMethodType, Method: $selectedIrrigationMethod');
    print('Weather Method Type: $selectedWeatherMethodType, Weather: $selectedWeather');
    
    bool isValid = selectedCrop != null &&
        selectedCrop!.isNotEmpty &&
        areaController.text.isNotEmpty &&
        selectedIrrigationMethod != null &&
        selectedIrrigationMethod!.isNotEmpty &&
        selectedWeather != null &&
        selectedWeather!.isNotEmpty;
    
    print('Form is valid: $isValid');
    return isValid;
  }

  Future<void> getGeminiResponse() async {
    setState(() {
      isLoading = true;
      aiResponse = null;
    });

    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text": """You are an AI assistant for a Smart Agricultural Advisory System. Based on the following farming details, provide specific recommendations:

Crop: $selectedCrop
Land Area: ${areaController.text} $selectedAreaUnit
Irrigation Method: $selectedIrrigationMethod
Weather Condition: $selectedWeather
Soil Type: $soilType

generate without any bold or any other formatting

Please provide detailed advice on:
1. Optimal sowing & harvesting periods
2. Irrigation strategies considering the current weather
3. Fertilizer recommendations
4. Pest & disease prevention measures
5. Any specific considerations based on the irrigation method
6. Sustainable farming practices for these conditions"""
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 1024,
      }
    };

    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          aiResponse = responseData['candidates']?.isNotEmpty == true
              ? responseData['candidates'][0]['content']['parts'][0]['text']
              : "No response from AI.";
        });
      } else {
        setState(() {
          aiResponse = "Error fetching data: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              AppColorSchemes.cropAdvisory['primary']!,
              AppColorSchemes.cropAdvisory['secondary']!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Icon(Icons.eco, color: Color(0xFF8BC34A), size: 32),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLocalizations.getPersonalizedRecommendations,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            appLocalizations.fillDetailsBelow,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Crop Selection
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.cropSelection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'list',
                              groupValue: selectedCropMethod,
                              onChanged: (value) {
                                setState(() {
                                  selectedCropMethod = value;
                                  selectedCrop = null; // Reset selection when changing method
                                });
                              },
                            ),
                            Text(appLocalizations.selectFromList),
                            Radio<String>(
                              value: 'manual',
                              groupValue: selectedCropMethod,
                              onChanged: (value) {
                                setState(() {
                                  selectedCropMethod = value;
                                  selectedCrop = null; // Reset selection when changing method
                                });
                              },
                            ),
                            Text(appLocalizations.enterManually),
                          ],
                        ),
                        if (selectedCropMethod == 'list')
                          _buildCropDropdown(appLocalizations),
                        if (selectedCropMethod == 'manual')
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: appLocalizations.enterCropName,
                            ),
                            onChanged: (value) {
                              setState(() => selectedCrop = value);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Land Area Input
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.landArea,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: areaController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: appLocalizations.enterArea,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            _buildAreaUnitDropdown(appLocalizations),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Add this new Irrigation Method Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.irrigationMethod,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'list',
                              groupValue: selectedIrrigationMethodType,
                              onChanged: (value) {
                                setState(() {
                                  selectedIrrigationMethodType = value;
                                  selectedIrrigationMethod = null; // Reset selection when changing method
                                });
                              },
                            ),
                            Text(appLocalizations.selectFromList),
                            Radio<String>(
                              value: 'manual',
                              groupValue: selectedIrrigationMethodType,
                              onChanged: (value) {
                                setState(() {
                                  selectedIrrigationMethodType = value;
                                  selectedIrrigationMethod = null; // Reset selection when changing method
                                });
                              },
                            ),
                            Text(appLocalizations.enterManually),
                          ],
                        ),
                        if (selectedIrrigationMethodType == 'list')
                          _buildIrrigationDropdown(appLocalizations),
                        if (selectedIrrigationMethodType == 'manual')
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: appLocalizations.enterIrrigationMethod,
                            ),
                            onChanged: (value) {
                              setState(() => selectedIrrigationMethod = value);
                            },
                          ),
                        SizedBox(height: 8),
                        // Optional: Add irrigation method description
                        if (selectedIrrigationMethod != null && 
                            selectedIrrigationMethod == 'list')
                          Text(
                            getIrrigationDescription(selectedIrrigationMethod!),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Weather Conditions Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.weatherConditions,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'list',
                              groupValue: selectedWeatherMethodType,
                              onChanged: (value) {
                                setState(() {
                                  selectedWeatherMethodType = value;
                                  selectedWeather = null; // Reset selection when changing method
                                });
                              },
                            ),
                            Text(appLocalizations.selectFromList),
                            Radio<String>(
                              value: 'manual',
                              groupValue: selectedWeatherMethodType,
                              onChanged: (value) {
                                setState(() {
                                  selectedWeatherMethodType = value;
                                  selectedWeather = null; // Reset selection when changing method
                                });
                              },
                            ),
                            Text(appLocalizations.enterManually),
                          ],
                        ),
                        if (selectedWeatherMethodType == 'list')
                          _buildWeatherDropdown(appLocalizations),
                        if (selectedWeatherMethodType == 'manual')
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: appLocalizations.enterWeatherCondition,
                            ),
                            onChanged: (value) {
                              setState(() => selectedWeather = value);
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8BC34A),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: isFormValid() 
                        ? () async {
                            // Add a print statement to debug
                            print('Button pressed! Form is valid.');
                            print('Selected Crop: $selectedCrop');
                            print('Area: ${areaController.text} $selectedAreaUnit');
                            print('Irrigation: $selectedIrrigationMethod');
                            print('Weather: $selectedWeather');
                            
                            await getGeminiResponse(); // Make sure to await the API call
                          }
                        : null,
                    child: Text(
                      appLocalizations.getAdvisory,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Add loading indicator and response section
                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (aiResponse != null) ...[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(aiResponse!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add this helper method for irrigation descriptions
  String getIrrigationDescription(String method) {
    switch (method) {
      case 'drip':
        return 'Water-efficient method that delivers water directly to plant roots through a network of pipes';
      case 'sprinkler':
        return 'Overhead irrigation that simulates rainfall, suitable for many types of crops';
      case 'flood':
        return 'Traditional method of flooding the entire field, commonly used in rice cultivation';
      case 'furrow':
        return 'Water flows through small channels between crop rows, good for row crops';
      case 'centerPivot':
        return 'Mechanized sprinkler system that rotates around a central pivot, ideal for large fields';
      case 'subsurfaceDrip':
        return 'Underground drip system that reduces water evaporation and promotes deep root growth';
      case 'microSprinkler':
        return 'Low-pressure sprinklers providing uniform water distribution for orchards and vegetables';
      case 'surface':
        return 'Traditional method where water flows over the soil surface by gravity';
      case 'basin':
        return 'Method where level areas are flooded with water, suitable for orchards';
      case 'borderStrip':
        return 'Long rectangular strips with raised borders for controlled flooding';
      default:
        return '';
    }
  }

  Widget _buildCropDropdown(AppLocalizations localizations) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      hint: Text(localizations.selectCrop),
      value: selectedCrop,
      items: crops.map((String cropKey) {
        // Use switch statement instead of reflection
        String translation = _getCropTranslation(localizations, cropKey);
        return DropdownMenuItem(
          value: cropKey,
          child: Text(translation),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedCrop = value);
      },
    );
  }

  Widget _buildIrrigationDropdown(AppLocalizations localizations) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      hint: Text(localizations.selectIrrigationMethod),
      value: selectedIrrigationMethod,
      items: irrigationMethods.map((String methodKey) {
        String translation = _getIrrigationTranslation(localizations, methodKey);
        return DropdownMenuItem(
          value: methodKey,
          child: Text(translation),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedIrrigationMethod = value);
      },
    );
  }

  Widget _buildWeatherDropdown(AppLocalizations localizations) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      hint: Text(localizations.selectWeatherCondition),
      value: selectedWeather,
      items: weatherConditions.map((String weatherKey) {
        String translation = _getWeatherTranslation(localizations, weatherKey);
        return DropdownMenuItem(
          value: weatherKey,
          child: Text(translation),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedWeather = value);
      },
    );
  }

  Widget _buildAreaUnitDropdown(AppLocalizations localizations) {
    return DropdownButton<String>(
      value: selectedAreaUnit,
      items: areaUnits.map((String unitKey) {
        String translation = _getAreaUnitTranslation(localizations, unitKey);
        return DropdownMenuItem(
          value: unitKey,
          child: Text(translation),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedAreaUnit = value!);
      },
    );
  }

  // Helper methods for translations
  String _getCropTranslation(AppLocalizations localizations, String key) {
    switch (key) {
      case 'wheat': return localizations.cropsWheat;
      case 'rice': return localizations.cropsRice;
      case 'cotton': return localizations.cropsCotton;
      case 'sugarcane': return localizations.cropsSugarcane;
      case 'maize': return localizations.cropsMaize;
      case 'soybean': return localizations.cropsSoybean;
      case 'potato': return localizations.cropsPotato;
      case 'tomato': return localizations.cropsTomato;
      case 'onion': return localizations.cropsOnion;
      case 'groundnut': return localizations.cropsGroundnut;
      case 'chickpea': return localizations.cropsChickpea;
      case 'mustard': return localizations.cropsMustard;
      case 'sunflower': return localizations.cropsSunflower;
      case 'turmeric': return localizations.cropsTurmeric;
      case 'ginger': return localizations.cropsGinger;
      case 'garlic': return localizations.cropsGarlic;
      case 'chili': return localizations.cropsChili;
      case 'cauliflower': return localizations.cropsCauliflower;
      case 'cabbage': return localizations.cropsCabbage;
      case 'carrot': return localizations.cropsCarrot;
      case 'peas': return localizations.cropsPeas;
      case 'beans': return localizations.cropsBeans;
      case 'cucumber': return localizations.cropsCucumber;
      case 'eggplant': return localizations.cropsEggplant;
      case 'okra': return localizations.cropsOkra;
      default: return key;
    }
  }

  String _getIrrigationTranslation(AppLocalizations localizations, String key) {
    switch (key) {
      case 'drip': return localizations.irrigationTypesDrip;
      case 'sprinkler': return localizations.irrigationTypesSprinkler;
      case 'flood': return localizations.irrigationTypesFlood;
      case 'furrow': return localizations.irrigationTypesFurrow;
      case 'centerPivot': return localizations.irrigationTypesCenterPivot;
      case 'subsurfaceDrip': return localizations.irrigationTypesSubsurfaceDrip;
      case 'microSprinkler': return localizations.irrigationTypesMicroSprinkler;
      case 'surface': return localizations.irrigationTypesSurface;
      case 'basin': return localizations.irrigationTypesBasin;
      case 'borderStrip': return localizations.irrigationTypesBorderStrip;
      default: return key;
    }
  }

  String _getWeatherTranslation(AppLocalizations localizations, String key) {
    switch (key) {
      case 'sunny': return localizations.weatherTypesSunny;
      case 'partlyCloudy': return localizations.weatherTypesPartlyCloudy;
      case 'overcast': return localizations.weatherTypesOvercast;
      case 'lightRain': return localizations.weatherTypesLightRain;
      case 'heavyRain': return localizations.weatherTypesHeavyRain;
      case 'thunderstorm': return localizations.weatherTypesThunderstorm;
      case 'windy': return localizations.weatherTypesWindy;
      case 'hotHumid': return localizations.weatherTypesHotHumid;
      case 'coldDry': return localizations.weatherTypesColdDry;
      case 'foggy': return localizations.weatherTypesFoggy;
      case 'hazy': return localizations.weatherTypesHazy;
      case 'drought': return localizations.weatherTypesDrought;
      case 'highTemp': return localizations.weatherTypesHighTemp;
      case 'lowTemp': return localizations.weatherTypesLowTemp;
      default: return key;
    }
  }

  String _getAreaUnitTranslation(AppLocalizations localizations, String key) {
    switch (key) {
      case 'acres': return localizations.areaUnitsAcres;
      case 'hectares': return localizations.areaUnitsHectares;
      case 'squareMeters': return localizations.areaUnitsSquareMeters;
      case 'squareFeet': return localizations.areaUnitsSquareFeet;
      case 'guntha': return localizations.areaUnitsGuntha;
      case 'bigha': return localizations.areaUnitsBigha;
      default: return key;
    }
  }
} 

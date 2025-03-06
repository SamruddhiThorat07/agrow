import 'package:flutter/material.dart';

class CropAdvisoryScreen extends StatefulWidget {
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

  final List<String> crops = ["Wheat", "Rice", "Cotton", "Sugarcane", "Maize"];
  final List<String> irrigationMethods = ["Drip", "Sprinkler", "Flood", "Furrow"];
  final List<String> weatherConditions = ["Sunny", "Rainy", "Cloudy", "Windy"];
  final List<String> areaUnits = ["Acres", "Hectares", "Square Meters"];
  String selectedAreaUnit = "Acres";

  @override
  void initState() {
    super.initState();
    // Set default values
    selectedCropMethod = 'list';
    selectedIrrigationMethodType = 'list';
    selectedWeatherMethodType = 'list';
  }

  bool isFormValid() {
    return (selectedCropMethod != null && selectedCrop != null) &&
        areaController.text.isNotEmpty &&
        (selectedIrrigationMethodType != null && selectedIrrigationMethod != null) &&
        (selectedWeatherMethodType != null && selectedWeather != null) &&
        soilType.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Advisory'),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: SingleChildScrollView(
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
                        'Get Personalized Crop Recommendations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Fill in the details below for customized advisory',
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
                      'Crop Selection',
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
                        Text('Select from list'),
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
                        Text('Enter manually'),
                      ],
                    ),
                    if (selectedCropMethod == 'list')
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hint: Text('Select crop'),
                        value: selectedCrop,
                        items: crops.map((String crop) {
                          return DropdownMenuItem(
                            value: crop,
                            child: Text(crop),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCrop = value);
                        },
                      ),
                    if (selectedCropMethod == 'manual')
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter crop name',
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
                      'Land Area',
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
                              hintText: 'Enter area',
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        DropdownButton<String>(
                          value: selectedAreaUnit,
                          items: areaUnits.map((String unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => selectedAreaUnit = value!);
                          },
                        ),
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
                      'Irrigation Method',
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
                        Text('Select from list'),
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
                        Text('Enter manually'),
                      ],
                    ),
                    if (selectedIrrigationMethodType == 'list')
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hint: Text('Select irrigation method'),
                        value: selectedIrrigationMethod,
                        items: irrigationMethods.map((String method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedIrrigationMethod = value);
                        },
                      ),
                    if (selectedIrrigationMethodType == 'manual')
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter irrigation method',
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
                      'Weather Conditions',
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
                        Text('Select from list'),
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
                        Text('Enter manually'),
                      ],
                    ),
                    if (selectedWeatherMethodType == 'list')
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hint: Text('Select weather condition'),
                        value: selectedWeather,
                        items: weatherConditions.map((String weather) {
                          return DropdownMenuItem(
                            value: weather,
                            child: Text(weather),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedWeather = value);
                        },
                      ),
                    if (selectedWeatherMethodType == 'manual')
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter weather condition',
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
                    ? () {
                        // Handle form submission
                      } 
                    : null,
                child: Text(
                  'Get Advisory',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this helper method for irrigation descriptions
  String getIrrigationDescription(String method) {
    switch (method) {
      case 'Drip':
        return 'Water-efficient method that delivers water directly to plant roots';
      case 'Sprinkler':
        return 'Overhead irrigation that simulates rainfall';
      case 'Flood':
        return 'Traditional method of flooding the entire field';
      case 'Furrow':
        return 'Water flows through small channels between crop rows';
      default:
        return '';
    }
  }
} 
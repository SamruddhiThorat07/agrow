import 'package:flutter/material.dart';
import '../utils/color_schemes.dart';

class PesticideScreen extends StatefulWidget {
  @override
  _PesticideScreenState createState() => _PesticideScreenState();
}

class _PesticideScreenState extends State<PesticideScreen> {
  String? selectedIssue;
  String? enteredIssue;
  String? selectedCropType;
  String? enteredCropType;
  String? selectedPestType;
  String? enteredPestType;
  String? selectedRegion;
  String? enteredRegion;
  String? selectedPlantingMonth;
  String extraInfo = '';
  final _formKey = GlobalKey<FormState>();
  int wordCount = 0;

  // Add selection method variables
  String issueSelectionMethod = 'dropdown';
  String cropSelectionMethod = 'dropdown';
  String pestSelectionMethod = 'dropdown';
  String regionSelectionMethod = 'dropdown';
  String monthSelectionMethod = 'dropdown';

  List<String> issues = [
    'Pests',
    'Diseases',
    'Weeds',
    'Soil Nutrient Deficiency',
    'Other',
  ];

  List<String> cropTypes = [
    'Sugarcane',
    'Cotton',
    'Soybeans',
    'Rice',
    'Wheat',
    'Maize',
    'Onions',
    'Chickpeas',
    'Pulses',
    'Groundnut',
    'Millets',
  ];

  List<String> pestTypes = [
    'Aphids',
    'Weevils',
    'Bollworm',
    'Armyworm',
    'Leafhopper',
  ];

  List<String> regions = [
    'Western Maharashtra',
    'Vidarbha',
    'Marathwada',
    'North Maharashtra',
    'Konkan',
  ];

  List<String> plantingMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Widget _buildSelectionSection({
    required String title,
    required String description,
    required String selectionMethod,
    required Function(String) onSelectionMethodChanged,
    required String? selectedValue,
    required Function(String?) onDropdownChanged,
    required Function(String) onTextChanged,
    required List<String> items,
    required String textFieldLabel,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'dropdown',
                        groupValue: selectionMethod,
                        onChanged: (value) => onSelectionMethodChanged(value!),
                        activeColor: Color(0xFF8BC34A),
                      ),
                      Text('Select from list'),
                      SizedBox(width: 16),
                      Radio<String>(
                        value: 'text',
                        groupValue: selectionMethod,
                        onChanged: (value) => onSelectionMethodChanged(value!),
                        activeColor: Color(0xFF8BC34A),
                      ),
                      Text('Enter manually'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (selectionMethod == 'dropdown')
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select ${title.split(" ").last}',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectedValue,
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onDropdownChanged,
              )
            else
              TextFormField(
                decoration: InputDecoration(
                  labelText: textFieldLabel,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: onTextChanged,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorSchemes.pesticide['primary']!,
              AppColorSchemes.pesticide['secondary']!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF8BC34A)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Fill in the details below for customized pesticide advisory.',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildSelectionSection(
                    title: 'Issue Type',
                    description: 'What issue are you facing with your crops?',
                    selectionMethod: issueSelectionMethod,
                    onSelectionMethodChanged: (value) => setState(() => issueSelectionMethod = value),
                    selectedValue: selectedIssue,
                    onDropdownChanged: (value) => setState(() => selectedIssue = value),
                    onTextChanged: (value) => setState(() => enteredIssue = value),
                    items: issues,
                    textFieldLabel: 'Enter Issue Type',
                  ),
                  SizedBox(height: 16),

                  _buildSelectionSection(
                    title: 'Crop Type',
                    description: 'What crop are you growing?',
                    selectionMethod: cropSelectionMethod,
                    onSelectionMethodChanged: (value) => setState(() => cropSelectionMethod = value),
                    selectedValue: selectedCropType,
                    onDropdownChanged: (value) => setState(() => selectedCropType = value),
                    onTextChanged: (value) => setState(() => enteredCropType = value),
                    items: cropTypes,
                    textFieldLabel: 'Enter Crop Type',
                  ),
                  SizedBox(height: 16),

                  _buildSelectionSection(
                    title: 'Pest Type',
                    description: 'What type of pest are you dealing with?',
                    selectionMethod: pestSelectionMethod,
                    onSelectionMethodChanged: (value) => setState(() => pestSelectionMethod = value),
                    selectedValue: selectedPestType,
                    onDropdownChanged: (value) => setState(() => selectedPestType = value),
                    onTextChanged: (value) => setState(() => enteredPestType = value),
                    items: pestTypes,
                    textFieldLabel: 'Enter Pest Type',
                  ),
                  SizedBox(height: 16),

                  _buildSelectionSection(
                    title: 'Region',
                    description: 'In which region is your farm located?',
                    selectionMethod: regionSelectionMethod,
                    onSelectionMethodChanged: (value) => setState(() => regionSelectionMethod = value),
                    selectedValue: selectedRegion,
                    onDropdownChanged: (value) => setState(() => selectedRegion = value),
                    onTextChanged: (value) => setState(() => enteredRegion = value),
                    items: regions,
                    textFieldLabel: 'Enter Region',
                  ),
                  SizedBox(height: 16),

                  _buildSelectionSection(
                    title: 'Planting Month',
                    description: 'When did you plant your crop?',
                    selectionMethod: monthSelectionMethod,
                    onSelectionMethodChanged: (value) => setState(() => monthSelectionMethod = value),
                    selectedValue: selectedPlantingMonth,
                    onDropdownChanged: (value) => setState(() => selectedPlantingMonth = value),
                    onTextChanged: (value) => setState(() => selectedPlantingMonth = value),
                    items: plantingMonths,
                    textFieldLabel: 'Enter Planting Month',
                  ),
                  SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Information',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Any other details you would like to add?',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Enter any extra information...',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                extraInfo = value;
                                wordCount = value.length;
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Character count: $wordCount/250',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process the data and send it to API
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8BC34A),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Get Advisory',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
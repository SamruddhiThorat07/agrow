import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/color_schemes.dart';

class SubsidiesScreen extends StatefulWidget {
  const SubsidiesScreen({super.key});

  @override
  _SubsidiesScreenState createState() => _SubsidiesScreenState();
}

class _SubsidiesScreenState extends State<SubsidiesScreen> {
  // Mock data for schemes
  final List<Map<String, dynamic>> schemes = [
    {
      'title': 'PM-KISAN',
      'description': 'Direct income support of ₹6000 per year to eligible farmer families',
      'type': 'Central Scheme',
      'target': 'All Farmers',
      'isEligible': true,
      'deadline': '2024-04-30',
      'applicationUrl': 'https://pmkisan.gov.in/',
    },
    {
      'title': 'Soil Health Card Scheme',
      'description': 'Free soil testing and recommendations for farmers',
      'type': 'State Scheme',
      'target': 'Organic Farmers',
      'isEligible': true,
      'deadline': '2024-03-15',
      'applicationUrl': 'https://soilhealth.dac.gov.in/',
    },
    {
      'title': 'Pradhan Mantri Fasal Bima Yojana',
      'description': 'Crop insurance scheme with minimal premium',
      'type': 'Central Scheme',
      'target': 'All Farmers',
      'isEligible': false,
      'deadline': '2024-05-31',
      'applicationUrl': 'https://pmfby.gov.in/',
    },
  ];

  Color getTagColor(String type) {
    if (type == 'Central Scheme' || type == 'All Farmers') {
      return Colors.purple;
    }
    return Colors.green;
  }

  bool isDeadlineApproaching(String deadline) {
    final deadlineDate = DateTime.parse(deadline);
    final daysUntilDeadline = deadlineDate.difference(DateTime.now()).inDays;
    return daysUntilDeadline <= 30;  // Warning if deadline is within 30 days
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
              AppColorSchemes.subsidies['primary']!,
              AppColorSchemes.subsidies['secondary']!,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: schemes.length,
            itemBuilder: (context, index) {
              final scheme = schemes[index];
              final isDeadlineClose = isDeadlineApproaching(scheme['deadline']);

              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deadline Warning if applicable
                    if (isDeadlineClose)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        color: Colors.amber.withOpacity(0.1),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              'Application deadline approaching: ${scheme['deadline']}',
                              style: TextStyle(color: Colors.amber[800]),
                            ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Tags
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  scheme['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: Text(
                                      scheme['type'],
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: getTagColor(scheme['type']),
                                  ),
                                  Chip(
                                    label: Text(
                                      scheme['target'],
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: getTagColor(scheme['target']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // Description
                          Text(
                            scheme['description'],
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),

                          // Eligibility Status
                          if (scheme['isEligible'])
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    'You are eligible for this scheme!',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.launch),
                                label: Text('Visit Website'),
                                onPressed: () async {
                                  final urlString = scheme['applicationUrl'];
                                  final url = Uri.parse(urlString);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not launch $urlString')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDeadlineClose 
                                    ? Colors.amber 
                                    : const Color(0xFF8BC34A),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              OutlinedButton.icon(
                                icon: Icon(Icons.info_outline),
                                label: Text('Details'),
                                onPressed: () {
                                  // Show scheme details
                                },
                              ),
                              OutlinedButton.icon(
                                icon: Icon(Icons.notifications_none),
                                label: Text('Remind'),
                                onPressed: () {
                                  // Set reminder
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
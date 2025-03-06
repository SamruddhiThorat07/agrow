import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpertCard extends StatelessWidget {
  final Map<String, dynamic> expert;
  final AppLocalizations appLocalizations;

  const ExpertCard({
    Key? key,
    required this.expert,
    required this.appLocalizations,
  }) : super(key: key);

  Color getTagColor(String type) {
    switch (type) {
      case 'Crops':
        return Colors.green;
      case 'Soil':
        return Colors.blue;
      case 'Govt.':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expert info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        expert['specialization'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(expert['experience']),
            SizedBox(height: 12),

            // Add the tags section here
            Wrap(
              spacing: 8,
              children: (expert['tags'] as List).map<Widget>((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: getTagColor(expert['type']),
                );
              }).toList(),
            ),
            SizedBox(height: 12),

            // Fee and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.feePerSession(expert['fee']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      expert['rating'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.chat, color: Colors.black),
                  label: Text(appLocalizations.chatButton,
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.phone, color: Colors.black),
                  label: Text(appLocalizations.callButton,
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.videocam, color: Colors.white),
                  label: Text(appLocalizations.videoButton,
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BC34A)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 
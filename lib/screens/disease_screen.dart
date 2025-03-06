 
import 'package:flutter/material.dart';

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({super.key});

  @override
  _DiseaseScreenState createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Disease')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  imagePath = 'mock_image_path'; // Replace with image_picker later
                });
              },
              child: const Text('Upload Crop Image'),
            ),
            const SizedBox(height: 20),
            imagePath != null
                ? Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Image Placeholder')),
                  )
                : const Text('No image uploaded'),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                title: Text('Disease: Early Blight (Mock)'),
                subtitle: Text('Solution: Use fungicide XYZ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
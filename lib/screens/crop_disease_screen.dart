import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CropDiseaseScreen extends StatefulWidget {
  @override
  _CropDiseaseScreenState createState() => _CropDiseaseScreenState();
}

class _CropDiseaseScreenState extends State<CropDiseaseScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String _response = "Upload an image to get results"; // AI Response

  final String _instructionPrompt = '''You are an expert AI in crop disease identification and treatment.
- You will receive an image of a diseased crop.
- Your task is to **identify the disease**, provide a **brief diagnosis**, and suggest **preventive & treatment measures**.
- Be **precise, actionable, and optimized for Indian agricultural conditions**.

### **Response Format (Important!):**  
1. Disease Name* (First line - for further pesticide search) ( Leave a blank line)
2. Diagnosis:(Brief explanation of the disease)  
3. Preventive Measures: (How to prevent it)  
4. Treatment Measures: (How to treat it, including organic & chemical solutions)

dont add numbers add bullets''';

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final Uint8List bytes = await photo.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _sendToGemini(bytes);
    }
  }

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _sendToGemini(bytes);
    }
  }

  Future<void> _sendToGemini(Uint8List imageBytes) async {
    const String apiKey = "AIzaSyAqnSFAI1M5ceD51u8FnBOsbFCfwuuCJn4"; // Replace with your API key
    const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-pro-exp-02-05:generateContent?key=$apiKey";

    // Convert image to base64
    String base64Image = base64Encode(imageBytes);

    // Prepare request body (Adjusted for the correct API format)
    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": _instructionPrompt},
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image
              }
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String aiResponse = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No response from AI.";
        setState(() {
          _response = aiResponse;
        });
      } else {
        setState(() {
          _response = "Error: ${response.statusCode} - ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Error sending request: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Disease Prediction'),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.eco, color: Colors.amber, size: 32),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detect Crop Diseases',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Take a photo or upload an image of your crop to identify diseases and get treatment recommendations.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8BC34A),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _takePhoto,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload Image'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF8BC34A),
                      side: BorderSide(color: Color(0xFF8BC34A)),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _uploadImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (_imageBytes != null)
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                  ),
                ),
              ),
            SizedBox(height: 24),
            Text(
              "Diagnostics:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                _response,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

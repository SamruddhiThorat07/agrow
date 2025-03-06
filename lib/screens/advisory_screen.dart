 
import 'package:flutter/material.dart';

class AdvisoryScreen extends StatelessWidget {
  const AdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farming Advice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Crop Type')),
            TextField(decoration: const InputDecoration(labelText: 'Land Type')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Advice'),
            ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                title: Text('Advice (Mock)'),
                subtitle: Text('Use drip irrigation for sandy soil.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
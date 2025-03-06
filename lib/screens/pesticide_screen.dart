 
import 'package:flutter/material.dart';

class PesticideScreen extends StatelessWidget {
  const PesticideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesticide Guide')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Crop')),
            TextField(decoration: const InputDecoration(labelText: 'Pest/Disease')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Guidance'),
            ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                title: Text('Guidance (Mock)'),
                subtitle: Text('Use pesticide ABC, 10ml/liter.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
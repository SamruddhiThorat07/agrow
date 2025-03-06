 
import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market & Schemes')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Card(
            child: ListTile(
              title: Text('Wheat: ₹25/kg'),
              subtitle: Text('Market Price (Mock)'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('PM Kisan Scheme'),
              subtitle: Text('₹6000/year subsidy (Mock)'),
            ),
          ),
        ],
      ),
    );
  }
}
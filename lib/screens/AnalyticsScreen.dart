import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.power),
                title: const Text('Power Usage'),
                subtitle: const Text('Today: 5.2 kWh'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.water_drop),
                title: const Text('Water Usage'),
                subtitle: const Text('Today: 120 L'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text('Temperature'),
                subtitle: const Text('Average: 23°C'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

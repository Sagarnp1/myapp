import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  Color getAppBarColor() {
    // Get the current hour
    final int hour = DateTime.now().hour;

    // Return blue for nighttime and yellow for daytime
    return (hour >= 6 && hour < 18) ? Color(0xFFCC5500) : Colors.blue.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: getAppBarColor(),
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

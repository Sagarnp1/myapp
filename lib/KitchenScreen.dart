import 'package:flutter/material.dart';

class KitchenScreen extends StatefulWidget {
  @override
  _KitchenScreenState createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  bool lightOn = false;
  double temperature = 22.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen'),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(lightOn ? Icons.lightbulb : Icons.lightbulb_outline),
                title: Text('Main Light'),
                trailing: Switch(
                  value: lightOn,
                  onChanged: (value) {
                    setState(() {
                      lightOn = value;
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.thermostat),
                title: Text('Temperature: ${temperature.toStringAsFixed(1)}°C'),
                trailing: Slider(
                  value: temperature,
                  min: 16.0,
                  max: 30.0,
                  onChanged: (value) {
                    setState(() {
                      temperature = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

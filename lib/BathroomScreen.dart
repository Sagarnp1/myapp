import 'package:flutter/material.dart';

class BathroomScreen extends StatefulWidget {
  @override
  _BathroomScreenState createState() => _BathroomScreenState();
}

class _BathroomScreenState extends State<BathroomScreen> {
  bool lightOn = false;
  bool fanOn = false;
  bool heaterOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bathroom'),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(lightOn ? Icons.lightbulb : Icons.lightbulb_outline),
                title: const Text('Light'),
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
                leading: Icon(fanOn ? Icons.air : Icons.air_outlined),
                title: const Text('Exhaust Fan'),
                trailing: Switch(
                  value: fanOn,
                  onChanged: (value) {
                    setState(() {
                      fanOn = value;
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

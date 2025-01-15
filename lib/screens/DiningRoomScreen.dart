import 'package:flutter/material.dart';

class DiningRoomScreen extends StatefulWidget {
  @override
  _DiningRoomScreenState createState() => _DiningRoomScreenState();
}

class _DiningRoomScreenState extends State<DiningRoomScreen> {
  bool lightOn = false;
  double brightness = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dining Room'),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(lightOn ? Icons.lightbulb : Icons.lightbulb_outline),
                title: const Text('Chandelier'),
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
                leading: const Icon(Icons.brightness_6),
                title: Text('Brightness: ${(brightness * 100).toInt()}%'),
                trailing: Slider(
                  value: brightness,
                  onChanged: (value) {
                    setState(() {
                      brightness = value;
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

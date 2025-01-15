import 'package:flutter/material.dart';

class LivingRoomScreen extends StatefulWidget {
  @override
  _LivingRoomScreenState createState() => _LivingRoomScreenState();
}

class _LivingRoomScreenState extends State<LivingRoomScreen> {
  bool tvOn = false;
  bool acOn = false;
  double brightness = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Living Room'),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(tvOn ? Icons.tv : Icons.tv_off),
                title: const Text('TV'),
                trailing: Switch(
                  value: tvOn,
                  onChanged: (value) {
                    setState(() {
                      tvOn = value;
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(acOn ? Icons.ac_unit : Icons.ac_unit_outlined),
                title: const Text('AC'),
                trailing: Switch(
                  value: acOn,
                  onChanged: (value) {
                    setState(() {
                      acOn = value;
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

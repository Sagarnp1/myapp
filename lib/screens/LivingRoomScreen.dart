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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E1E1E),
              const Color(0xFF2B2B2B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // TV Control Card
              Card(
                color: const Color(0xFF333333),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    tvOn ? Icons.tv : Icons.tv_off,
                    size: 36,
                    color: tvOn ? Colors.green : Colors.red,
                  ),
                  title: const Text(
                    'TV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Switch(
                    value: tvOn,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        tvOn = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // AC Control Card
              Card(
                color: const Color(0xFF333333),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    acOn ? Icons.ac_unit : Icons.ac_unit_outlined,
                    size: 36,
                    color: acOn ? Colors.blue : Colors.grey,
                  ),
                  title: const Text(
                    'AC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Switch(
                    value: acOn,
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        acOn = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Brightness Slider
              Card(
                color: const Color(0xFF333333),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Brightness',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: brightness,
                        min: 0,
                        max: 1,
                        divisions: 10,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            brightness = value;
                          });
                        },
                      ),
                      Text(
                        'Brightness: ${(brightness * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

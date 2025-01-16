import 'package:flutter/material.dart';

class KitchenPage extends StatefulWidget {
  @override
  _KitchenPageState createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final TextEditingController _switchboardController = TextEditingController();
  bool _isConnected = false;
  Map<String, dynamic> devices = {
    "Bulb": false,
    "Fan": 0, // 0: Off, 1: Low, 2: Medium, 3: High
    "TV": false,
    "Refrigerator": false,
    "Oven": false,
  };

  void connectToSwitch() {
    if (_switchboardController.text.isNotEmpty) {
      setState(() {
        _isConnected = true;
      });
      // Simulate connection to switch using the API/ID
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Connected to switch: ${_switchboardController.text}')),
      );
    }
  }

  void toggleDevice(String device) {
    setState(() {
      if (device == "Fan") {
        devices[device] = (devices[device] + 1) % 4;
      } else {
        devices[device] = !devices[device];
      }
    });
  }

  String fanSpeedLabel(int speed) {
    switch (speed) {
      case 1:
        return "Low";
      case 2:
        return "Medium";
      case 3:
        return "High";
      default:
        return "Off";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/nightkitchen.jpg',
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                if (!_isConnected) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _switchboardController,
                      decoration: InputDecoration(
                        labelText: 'Enter Switchboard API/ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: connectToSwitch,
                    child: Text('Connect to Switch'),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Connected to Switch: ${_switchboardController.text}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (var device in devices.keys)
                    Card(
                      color: Colors.black.withOpacity(0.6),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          device,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: device == "Fan"
                            ? DropdownButton<int>(
                                value: devices[device],
                                dropdownColor: Colors.black,
                                items: [
                                  DropdownMenuItem(
                                      value: 0, child: Text("Off")),
                                  DropdownMenuItem(
                                      value: 1, child: Text("Low")),
                                  DropdownMenuItem(
                                      value: 2, child: Text("Medium")),
                                  DropdownMenuItem(
                                      value: 3, child: Text("High")),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    devices[device] = value!;
                                  });
                                },
                              )
                            : Switch(
                                value: devices[device],
                                onChanged: (value) => toggleDevice(device),
                                activeColor: Colors.green,
                              ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ));
  }
}

//
import 'package:flutter/material.dart';

class KitchenPage extends StatefulWidget {
  @override
  _KitchenPageState createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final TextEditingController _switchboardController = TextEditingController();
  bool _isConnected = false;
  bool _hasSelectedDevices = false;

  // Enhanced device configuration
  final Map<String, Map<String, dynamic>> availableDevices = {
    "Hue Lights": {
      "selected": false,
      "icon": Icons.lightbulb_outline,
      "type": "intensity",
      "state": false,
      "intensity": 50,
    },
    "Side Lamp": {
      "selected": false,
      "icon": Icons.light,
      "type": "intensity",
      "state": false,
      "intensity": 50,
    },
    "Air Condition": {
      "selected": false,
      "icon": Icons.ac_unit,
      "type": "temperature",
      "state": false,
      "temperature": 24,
      "mode": "cool", // cool, heat, auto
    },
    "Music": {
      "selected": false,
      "icon": Icons.music_note,
      "type": "volume",
      "state": false,
      "volume": 50,
    },
    "Wi-Fi": {
      "selected": false,
      "icon": Icons.wifi,
      "type": "switch",
      "state": false,
    },
    "Fan": {
      "selected": false,
      "icon": Icons.rotate_right,
      "type": "speed",
      "state": false,
      "speed": 0,
    },
    "TV": {
      "selected": false,
      "icon": Icons.tv,
      "type": "volume",
      "state": false,
      "volume": 50,
    },
    "Refrigerator": {
      "selected": false,
      "icon": Icons.kitchen,
      "type": "temperature",
      "state": false,
      "temperature": 4,
      "mode": "cool",
    },
  };

  Map<String, Map<String, dynamic>> selectedDevices = {};

  void connectToSwitch() {
    if (_switchboardController.text.isNotEmpty) {
      setState(() {
        _isConnected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to switch: ${_switchboardController.text}')),
      );
    }
  }

  void confirmDeviceSelection() {
    Map<String, Map<String, dynamic>> selected = {};
    availableDevices.forEach((device, data) {
      if (data['selected']) {
        selected[device] = Map<String, dynamic>.from(data);
      }
    });

    setState(() {
      selectedDevices = selected;
      _hasSelectedDevices = true;
    });
  }

  Widget buildDeviceControls(String deviceName, Map<String, dynamic> device) {
    switch (device['type']) {
      case 'intensity':
        return Column(
          children: [
            Switch(
              value: device['state'],
              activeColor: Color(0xFFCC5500),
              onChanged: (value) {
                setState(() {
                  device['state'] = value;
                });
              },
            ),
            if (device['state'])
              Column(
                children: [
                  Text('Intensity: ${device['intensity']}%'),
                  Slider(
                    value: device['intensity'].toDouble(),
                    min: 0,
                    max: 100,
                    activeColor: Color(0xFFCC5500),
                    onChanged: (value) {
                      setState(() {
                        device['intensity'] = value.round();
                      });
                    },
                  ),
                ],
              ),
          ],
        );

      case 'temperature':
        return Column(
          children: [
            Switch(
              value: device['state'],
              activeColor: Color(0xFFCC5500),
              onChanged: (value) {
                setState(() {
                  device['state'] = value;
                });
              },
            ),
            if (device['state'])
              Column(
                children: [
                  Text('Temperature: ${device['temperature']}°C'),
                  Slider(
                    value: device['temperature'].toDouble(),
                    min: deviceName == "Refrigerator" ? 1 : 16,
                    max: deviceName == "Refrigerator" ? 8 : 30,
                    activeColor: Color(0xFFCC5500),
                    onChanged: (value) {
                      setState(() {
                        device['temperature'] = value.round();
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: device['mode'],
                    items: <String>['cool', 'heat', 'auto']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        device['mode'] = newValue!;
                      });
                    },
                  ),
                ],
              ),
          ],
        );

      case 'volume':
        return Column(
          children: [
            Switch(
              value: device['state'],
              activeColor: Color(0xFFCC5500),
              onChanged: (value) {
                setState(() {
                  device['state'] = value;
                });
              },
            ),
            if (device['state'])
              Column(
                children: [
                  Text('Volume: ${device['volume']}%'),
                  Slider(
                    value: device['volume'].toDouble(),
                    min: 0,
                    max: 100,
                    activeColor: Color(0xFFCC5500),
                    onChanged: (value) {
                      setState(() {
                        device['volume'] = value.round();
                      });
                    },
                  ),
                ],
              ),
          ],
        );

      case 'speed':
        return Column(
          children: [
            Switch(
              value: device['state'],
              activeColor: Color(0xFFCC5500),
              onChanged: (value) {
                setState(() {
                  device['state'] = value;
                });
              },
            ),
            if (device['state'])
              DropdownButton<int>(
                value: device['speed'],
                items: [
                  DropdownMenuItem(value: 0, child: Text("Off")),
                  DropdownMenuItem(value: 1, child: Text("Low")),
                  DropdownMenuItem(value: 2, child: Text("Medium")),
                  DropdownMenuItem(value: 3, child: Text("High")),
                ],
                onChanged: (value) {
                  setState(() {
                    device['speed'] = value;
                  });
                },
              ),
          ],
        );

      default:
        return Switch(
          value: device['state'],
          activeColor: Color(0xFFCC5500),
          onChanged: (value) {
            setState(() {
              device['state'] = value;
            });
          },
        );
    }
  }

  Widget buildDeviceGrid() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${selectedDevices.length} devices connected",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: selectedDevices.length,
              itemBuilder: (context, index) {
                String deviceName = selectedDevices.keys.elementAt(index);
                var device = selectedDevices[deviceName]!;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          device['icon'],
                          size: 32,
                          color: device['state'] ? Color(0xFFCC5500) : Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          deviceName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        buildDeviceControls(deviceName, device),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceSelectionList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Select Kitchen Devices',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: availableDevices.length,
            itemBuilder: (context, index) {
              String device = availableDevices.keys.elementAt(index);
              var deviceData = availableDevices[device]!;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  leading: Icon(deviceData['icon']),
                  title: Text(device),
                  trailing: Checkbox(
                    value: deviceData['selected'],
                    activeColor: Color(0xFFCC5500),
                    onChanged: (bool? value) {
                      setState(() {
                        deviceData['selected'] = value!;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: confirmDeviceSelection,
            child: Text('Confirm Selection'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCC5500),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Kitchen Control'),
        backgroundColor: Color(0xFFCC5500),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/kitche.jpg"), // Use AssetImage for local assets
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: !_isConnected
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _switchboardController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter Switchboard API/ID',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: connectToSwitch,
                    child: Text('Connect to Switch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCC5500),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          )
              : !_hasSelectedDevices
              ? buildDeviceSelectionList()
              : buildDeviceGrid(),
        ),
      ),
    );
  }
}
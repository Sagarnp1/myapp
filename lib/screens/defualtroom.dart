import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultRoomPage extends StatefulWidget {
  final String roomName;
  final String backgroundImage;

  const DefaultRoomPage({
    super.key,
    required this.roomName,
    required this.backgroundImage,
  });

  @override
  _DefaultRoomPageState createState() => _DefaultRoomPageState();
}

class _DefaultRoomPageState extends State<DefaultRoomPage> {
  final TextEditingController _switchboardController = TextEditingController();
  bool _isConnected = false;
  bool _hasSwitchSelected = false;
  bool _hasSelectedDevices = false;
  int? _selectedSwitch;

  final List<int> availableSwitches = [1, 2, 3, 4, 5, 6];

  final Map<String, Map<String, dynamic>> availableDevices = {
    "Main Light": {
      "selected": false,
      "icon": Icons.lightbulb_outline,
      "type": "intensity",
      "state": false,
      "intensity": 50,
    },
    "Secondary Light": {
      "selected": false,
      "icon": Icons.light,
      "type": "intensity",
      "state": false,
      "intensity": 30,
    },
    "AC": {
      "selected": false,
      "icon": Icons.ac_unit,
      "type": "temperature",
      "state": false,
      "temperature": 24,
      "mode": "cool",
    },
    "Smart TV": {
      "selected": false,
      "icon": Icons.tv,
      "type": "volume",
      "state": false,
      "volume": 30,
    },
    "Smart Curtains": {
      "selected": false,
      "icon": Icons.curtains,
      "type": "position",
      "state": false,
      "position": 0,
    },
    "Ceiling Fan": {
      "selected": false,
      "icon": Icons.rotate_right,
      "type": "speed",
      "state": false,
      "speed": 0,
    },
    "Ambient Light": {
      "selected": false,
      "icon": Icons.wb_twilight,
      "type": "intensity",
      "state": false,
      "intensity": 20,
    },
    "Air Purifier": {
      "selected": false,
      "icon": Icons.air,
      "type": "speed",
      "state": false,
      "speed": 0,
    },
    "Smart Speaker": {
      "selected": false,
      "icon": Icons.speaker,
      "type": "volume",
      "state": false,
      "volume": 50,
    },
    "Smart Lock": {
      "selected": false,
      "icon": Icons.lock,
      "type": "switch",
      "state": false,
    },
    "Motion Sensor": {
      "selected": false,
      "icon": Icons.sensors,
      "type": "switch",
      "state": false,
    },
    "Security Camera": {
      "selected": false,
      "icon": Icons.camera_outdoor,
      "type": "switch",
      "state": false,
    }
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

  Widget buildSwitchSelection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select Switch Number',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: availableSwitches.length,
            itemBuilder: (context, index) {
              int switchNum = availableSwitches[index];
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedSwitch == switchNum
                      ? Color(0xFFCC5500)
                      : Colors.grey.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () {
                  setState(() {
                    _selectedSwitch = switchNum;
                    _hasSwitchSelected = true;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power_settings_new, size: 30),
                    SizedBox(height: 8),
                    Text(
                      'Switch $switchNum',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
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
                  Text(
                    'Intensity: ${device['intensity']}%',
                    style: TextStyle(color: Colors.white),
                  ),
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
                  Text(
                    'Temperature: ${device['temperature']}°C',
                    style: TextStyle(color: Colors.white),
                  ),
                  Slider(
                    value: device['temperature'].toDouble(),
                    min: 16,
                    max: 30,
                    activeColor: Color(0xFFCC5500),
                    onChanged: (value) {
                      setState(() {
                        device['temperature'] = value.round();
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
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.white),
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
                  Text(
                    'Volume: ${device['volume']}%',
                    style: TextStyle(color: Colors.white),
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "${selectedDevices.length} devices connected",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
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
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        device['icon'],
                        size: 32,
                        color: device['state'] ? Color(0xFFCC5500) : Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        deviceName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      //SizedBox(height: 16),
                      buildDeviceControls(deviceName, device),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildDeviceSelectionList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Select ${widget.roomName} Devices',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: availableDevices.length,
            itemBuilder: (context, index) {
              String device = availableDevices.keys.elementAt(index);
              var deviceData = availableDevices[device]!;
              return Card(
                margin: EdgeInsets.only(bottom: 8),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCC5500),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text('Confirm Selection'),
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
        title: Text('${widget.roomName} Control'),
        backgroundColor: Color(0xFFCC5500),
        elevation: 0,
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.backgroundImage),
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
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
    ),
    ],
    ),
    ),
    )
        : !_hasSwitchSelected
        ? buildSwitchSelection()
        : !_hasSelectedDevices
        ? buildDeviceSelectionList()
        : buildDeviceGrid(),
          ),
      ),
    );
  }
}

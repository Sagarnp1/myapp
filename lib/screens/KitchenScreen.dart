// import 'package:flutter/material.dart';
//
// class KitchenPage extends StatefulWidget {
//   @override
//   _KitchenPageState createState() => _KitchenPageState();
// }
//
// class _KitchenPageState extends State<KitchenPage> {
//   final TextEditingController _switchboardController = TextEditingController();
//   bool _isConnected = false;
//   Map<String, dynamic> devices = {
//     "Bulb": false,
//     "Fan": 0, // 0: Off, 1: Low, 2: Medium, 3: High
//     "TV": false,
//     "Refrigerator": false,
//     "Oven": false,
//   };
//
//   void connectToSwitch() {
//     if (_switchboardController.text.isNotEmpty) {
//       setState(() {
//         _isConnected = true;
//       });
//       // Simulate connection to switch using the API/ID
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content:
//                 Text('Connected to switch: ${_switchboardController.text}')),
//       );
//     }
//   }
//
//   void toggleDevice(String device) {
//     setState(() {
//       if (device == "Fan") {
//         devices[device] = (devices[device] + 1) % 4;
//       } else {
//         devices[device] = !devices[device];
//       }
//     });
//   }
//
//   String fanSpeedLabel(int speed) {
//     switch (speed) {
//       case 1:
//         return "Low";
//       case 2:
//         return "Medium";
//       case 3:
//         return "High";
//       default:
//         return "Off";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage(
//                     'assets/kit.jpg',
//                   ),
//                   fit: BoxFit.cover)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 350),
//               if (!_isConnected) ...[
//                 Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: TextField(
//                     controller: _switchboardController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter Switchboard API/ID',
//                       border: OutlineInputBorder(),fillColor: Colors.grey.withOpacity(0.6),filled: true,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   onPressed: connectToSwitch,
//                   child: Text('Connect to Switch'),
//                 ),
//               ] else ...[
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     'Connected to Switch: ${_switchboardController.text}',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 for (var device in devices.keys)
//                   Card(
//                     color: Colors.black.withOpacity(0.6),
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 8, horizontal: 16),
//                     child: ListTile(
//                       title: Text(
//                         device,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       trailing: device == "Fan"
//                           ? DropdownButton<int>(
//                               value: devices[device],
//                               dropdownColor: Colors.black,
//                               items: [
//                                 DropdownMenuItem(
//                                     value: 0, child: Text("Off")),
//                                 DropdownMenuItem(
//                                     value: 1, child: Text("Low")),
//                                 DropdownMenuItem(
//                                     value: 2, child: Text("Medium")),
//                                 DropdownMenuItem(
//                                     value: 3, child: Text("High")),
//                               ],
//                               onChanged: (value) {
//                                 setState(() {
//                                   devices[device] = value!;
//                                 });
//                               },
//                             )
//                           : Switch(
//                               value: devices[device],
//                               onChanged: (value) => toggleDevice(device),
//                               activeColor: Colors.green,
//                             ),
//                     ),
//                   ),
//               ],
//             ],
//           ),
//         ));
//   }
// }

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

  // All available household appliances with their icons
  final Map<String, Map<String, dynamic>> allDevices = {
    "Bulb": {
      "selected": false,
      "icon": Icons.lightbulb_outline,
      "activeIcon": Icons.lightbulb
    },
    "Fan": {
      "selected": false,
      "icon": Icons.rotate_right,
      "activeIcon": Icons.rotate_right
    },
    "TV": {
      "selected": false,
      "icon": Icons.tv_outlined,
      "activeIcon": Icons.tv
    },
    "Refrigerator": {
      "selected": false,
      "icon": Icons.kitchen_outlined,
      "activeIcon": Icons.kitchen
    },
    "Oven": {
      "selected": false,
      "icon": Icons.microwave_outlined,
      "activeIcon": Icons.microwave
    },
    "Microwave": {
      "selected": false,
      "icon": Icons.microwave_outlined,
      "activeIcon": Icons.microwave
    },
    "Coffee Maker": {
      "selected": false,
      "icon": Icons.coffee_outlined,
      "activeIcon": Icons.coffee
    },
    "Toaster": {
      "selected": false,
      "icon": Icons.kitchen_outlined,
      "activeIcon": Icons.kitchen
    },
    "Dishwasher": {
      "selected": false,
      "icon": Icons.wash_outlined,
      "activeIcon": Icons.wash
    },
    "Water Purifier": {
      "selected": false,
      "icon": Icons.water_drop_outlined,
      "activeIcon": Icons.water_drop
    },
    "Mixer Grinder": {
      "selected": false,
      "icon": Icons.blender_outlined,
      "activeIcon": Icons.blender
    },
    "Electric Kettle": {
      "selected": false,
      "icon": Icons.coffee_maker_outlined,
      "activeIcon": Icons.coffee_maker
    },
  };

  // Selected devices and their states
  Map<String, dynamic> selectedDevices = {};

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
    Map<String, dynamic> selected = {};
    allDevices.forEach((device, data) {
      if (data['selected']) {
        // Initialize Fan with speed 0, others with boolean false
        selected[device] = device == "Fan" ? 0 : false;
      }
    });

    setState(() {
      selectedDevices = selected;
      _hasSelectedDevices = true;
    });
  }

  void toggleDevice(String device) {
    setState(() {
      if (device == "Fan") {
        selectedDevices[device] = (selectedDevices[device] + 1) % 4;
      } else {
        selectedDevices[device] = !selectedDevices[device];
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

  Widget buildDeviceSelectionList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Select Kitchen Appliances',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: allDevices.length,
            itemBuilder: (context, index) {
              String device = allDevices.keys.elementAt(index);
              var deviceData = allDevices[device]!;
              return Dismissible(
                key: Key(device),
                background: Container(
                  color: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Icon(Icons.close, color: Colors.white),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                ),
                onDismissed: (direction) {
                  setState(() {
                    deviceData['selected'] = direction == DismissDirection.startToEnd;
                  });
                },
                child: Card(
                  color: Colors.black.withOpacity(0.6),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      deviceData['selected'] ? deviceData['activeIcon'] : deviceData['icon'],
                      color: Colors.white,
                      size: 28,
                    ),
                    title: Text(
                      device,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      deviceData['selected'] ? Icons.check_circle : Icons.circle_outlined,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        deviceData['selected'] = !deviceData['selected'];
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/kit.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 350),
            if (!_isConnected) ...[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: _switchboardController,
                  decoration: InputDecoration(
                    labelText: 'Enter Switchboard API/ID',
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey.withOpacity(0.6),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: connectToSwitch,
                child: Text('Connect to Switch'),
              ),
            ] else if (!_hasSelectedDevices) ...[
              Expanded(child: buildDeviceSelectionList()),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Connected to Switch: ${_switchboardController.text}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (var device in selectedDevices.keys)
                Card(
                  color: Colors.black.withOpacity(0.6),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      selectedDevices[device] is bool && selectedDevices[device]
                          ? allDevices[device]!['activeIcon']
                          : allDevices[device]!['icon'],
                      color: Colors.white,
                      size: 28,
                    ),
                    title: Text(
                      device,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: device == "Fan"
                        ? DropdownButton<int>(
                      value: selectedDevices[device],
                      dropdownColor: Colors.black,
                      items: [
                        DropdownMenuItem(value: 0, child: Text("Off")),
                        DropdownMenuItem(value: 1, child: Text("Low")),
                        DropdownMenuItem(value: 2, child: Text("Medium")),
                        DropdownMenuItem(value: 3, child: Text("High")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDevices[device] = value!;
                        });
                      },
                    )
                        : Switch(
                      value: selectedDevices[device],
                      onChanged: (value) => toggleDevice(device),
                      activeColor: Colors.green,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
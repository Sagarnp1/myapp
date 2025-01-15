import 'dart:async';

import 'package:app/weather/apiResponse.dart';
import 'package:app/weather/weatherModel.dart';
import 'package:app/widgeets/custom_card.dart';
import 'package:app/widgeets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'AnalyticsScreen.dart';
import 'Profile.dart';
import 'model/custom_room.dart';
import 'model/user_location.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentPageIndex = 0;
  DateTime? lastBackPressTime;
  late Timer timer;
  late String currentTime;
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${_formatDigit(now.hour)}:${_formatDigit(now.minute)}:${_formatDigit(now.second)}';
  }

  String _formatDigit(int number) {
    return number.toString().padLeft(2, '0');
  }
  //weater
  var latitude;
  var longitude;
  WeatherClient client = WeatherClient();

  Future<WeatherData?>? _futureData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLocationPermissionAndFetchData();
    _futureData = _getCurrentWeatherData();
    currentTime = _getCurrentTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }
  void _checkLocationPermissionAndFetchData() async {
    if (await Permission.location.request().isGranted) {
      setState(() {
        _futureData = _getCurrentWeatherData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required to fetch weather data.')),
      );
    }
  }String getCurrentDate() {
    final now = DateTime.now();
    final monthNames = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    final day = now.day.toString().padLeft(2, '0');
    final month = monthNames[now.month - 1];
    return '$month $day';
  }

  Future<WeatherData?> _getCurrentWeatherData() async {
    UserLocation currentLocation = UserLocation();
    await currentLocation.getLocation();
    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;
    return await client.getApiData(latitude, longitude);
  }
  // Make rooms list mutable
  LinearGradient getGradientForTimeOfDay() {
    final now = DateTime.now();
    if (now.hour >= 6 && now.hour < 18) {
      // Daytime Gradient
      return LinearGradient(
        colors: [Color(0xFFCC5500), Color(0xFFFFA500)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    } else {
      // Nighttime Gradient
      return const LinearGradient(
        colors: [
          Color.fromRGBO(20, 30, 48, 1),
          Color.fromRGBO(36, 59, 85, 1),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
  }

  void _showAddRoomDialog() {
    final _nameController = TextEditingController();
    final _imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Room Name',
                    hintText: 'Enter room name',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    labelText: 'Image Path',
                    hintText: 'assets/room_image.jpg',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _imageController.text.isNotEmpty) {
                  setState(() {
                    rooms.add({
                      'name': _nameController.text,
                      'image': _imageController.text,
                      'screen': GenericRoomScreen(roomName: _nameController.text),
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Room added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (lastBackPressTime == null ||
            DateTime.now().difference(lastBackPressTime!) > Duration(seconds: 2)) {
          lastBackPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Home Dashboard'),
          backgroundColor: const Color(0xFFCC5500),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showAddRoomDialog,
            ),
          ],
        ),
        body: Container(decoration:  BoxDecoration(
        gradient: getGradientForTimeOfDay()),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                    child: CustomCard(currentTime: currentTime, currentDate: getCurrentDate(),
                      currentWeather:FutureBuilder<WeatherData?>(
                        future: _futureData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: Colors.white,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.white),
                            );
                          } else if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data?.temperature}°C',
                              style:  TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Gill Sans',
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return Text(
                              'No Data',
                              style: TextStyle(color: Colors.white),
                            );
                          }
                        },
                      ),),


                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return RoomCard(
                      name: room['name'],
                      image: room['image'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => room['screen']),
                        );
                      },
                    );
                  },
                ),
              ),
              NavigationBar(
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                  switch (index) {
                    case 0:
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                            (route) => false,
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                      break;
                  }
                },
                selectedIndex: currentPageIndex,
                destinations: const <Widget>[
                  NavigationDestination(
                    selectedIcon: Icon(Icons.dashboard),
                    icon: Icon(Icons.dashboard_outlined),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.analytics),
                    icon: Icon(Icons.analytics_outlined),
                    label: 'Analytics',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.person),
                    icon: Icon(Icons.person_outline),
                    label: 'Profile',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Generic Room Screen for dynamically added rooms
class GenericRoomScreen extends StatelessWidget {
  final String roomName;

  const GenericRoomScreen({Key? key, required this.roomName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Center(
        child: Text(
          '$roomName Controls',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Existing DigitalClock and RoomCard classes remain the same

// Rest of the code remains the same (DigitalClock and RoomCard classes)




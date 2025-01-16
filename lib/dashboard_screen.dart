import 'dart:async';

import 'package:app/model/user_location.dart';
import 'package:app/weather/apiResponse.dart';
import 'package:app/widgeets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'weather/weatherModel.dart';
import 'screens/KitchenScreen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  var latitude;
  var longitude;
  WeatherClient client = WeatherClient();

  Future<WeatherData?> _getCurrentWeatherData() async {
    UserLocation currentLocation = UserLocation();
    await currentLocation.getLocation();
    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;
    return await client.getApiData(latitude, longitude);
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    final day = now.day.toString().padLeft(2, '0');
    final month = monthNames[now.month - 1];
    return '$month $day';
  }

  void _checkLocationPermissionAndFetchData() async {
    if (await Permission.location.request().isGranted) {
      setState(() {
        _futureData = _getCurrentWeatherData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Location permission is required to fetch weather data.')),
      );
    }
  }

  Future<WeatherData?>? _futureData;
  @override
  void initState() {
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

  List<Map<String, dynamic>> rooms = [];

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  LinearGradient getGradientForTimeOfDay() {
    final now = DateTime.now();
    if (now.hour >= 6 && now.hour < 18) {
      return LinearGradient(
        colors: [Color(0xFFCC5500), Color(0xFFFFA500)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    } else {
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
          title: const Text('Add New Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    hintText: 'Enter room name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image Path',
                    hintText: 'Optional: Enter image path',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final roomName = _nameController.text.trim();
                final imagePath = _imageController.text.trim();

                if (roomName.isNotEmpty) {
                  String finalImagePath = imagePath;

                  if (imagePath.isEmpty) {
                    // Assign default images based on room name
                    switch (roomName.toLowerCase()) {
                      case 'kitchen':
                        finalImagePath = 'assets/kit.jpg';
                        break;
                      case 'dining room':
                        finalImagePath = 'assets/dining_room.jpg';
                        break;
                      case 'bathroom':
                        finalImagePath = 'assets/bathroom.jpg';
                        break;
                      case 'living room':
                        finalImagePath = 'assets/light1.jpg';
                        break;
                      default:
                        finalImagePath = 'assets/bg.jpg';
                    }
                  }

                  setState(() {
                    rooms.add({
                      'name': roomName,
                      'image': finalImagePath,
                      // Assign specific screen for Kitchen, else use GenericRoomScreen
                      'screen': roomName.toLowerCase() == 'kitchen'
                          ? KitchenPage()
                          : GenericRoomScreen(roomName: roomName),
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$roomName added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room name cannot be empty.')),
                  );
                }
              },
              child: const Text('Add'),
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
            DateTime.now().difference(lastBackPressTime!) >
                const Duration(seconds: 2)) {
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
          title: const Text(
            'Smart Home Dashboard',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFCC5500),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(gradient: getGradientForTimeOfDay()),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CustomCard(
                      currentTime: currentTime,
                      currentDate: getCurrentDate(),
                      currentWeather: FutureBuilder<WeatherData?>(
                        future: _futureData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          } else if (snapshot.hasError) {
                            return Text(
                              'No Network',
                              style: TextStyle(color: Colors.white),
                            );
                          } else if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data?.temperature}°C',
                              style: TextStyle(
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
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _showAddRoomDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Add Room',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => room['screen']),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Image.asset(
                                  room['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                room['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

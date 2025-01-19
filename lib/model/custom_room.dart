
import '../screens/BathroomScreen.dart';
import '../screens/DiningRoomScreen.dart';
import '../screens/kitchen_screen.dart';
import '../screens/LivingRoomScreen.dart';

List<Map<String, dynamic>> rooms = [
  {
    'name': 'Kitchen',
    'image': 'assets/kit.jpg',
    'screen': KitchenPage(),
  },
  {
    'name': 'Living Room',
    'image': 'assets/livingroom.jpg',
    'screen': LivingRoomPage(),
  },
  {
    'name': 'Dining Room',
    'image': 'assets/dining.jpg',
    'screen': DiningRoomPage(),
  },
  {
    'name': 'Bathroom',
    'image': 'assets/bathroom.jpg',
    'screen': BathroomPage(),
  },


];
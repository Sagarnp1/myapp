
import '../screens/BathroomScreen.dart';
import '../screens/DiningRoomScreen.dart';
import '../screens/kitchen_screen.dart';
import '../screens/LivingRoomScreen.dart';

List<Map<String, dynamic>> rooms = [
  {
    'name': 'Kitchen',
    'image': 'assets/kitchen.jpeg',
    'screen': KitchenPage(),
  },
  {
    'name': 'Living Room',
    'image': 'assets/living_room.jpg',
    'screen': LivingRoomScreen(),
  },
  {
    'name': 'Dining Room',
    'image': 'assets/dining.jpeg',
    'screen': DiningRoomScreen(),
  },
  {
    'name': 'Bathroom',
    'image': 'assets/bathroom.jpeg',
    'screen': BathroomScreen(),
  },
];
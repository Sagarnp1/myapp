// import 'package:geolocator/geolocator.dart';
//
// class UserLocation {
//   double? latitude;
//   double? longitude;
//   UserLocation({this.latitude, this.longitude});
//
//   Future getLocation() async {
//     try {
//       LocationPermission permission;
//       permission = await Geolocator.requestPermission();
//       permission = await Geolocator.checkPermission();
//
//       Position userPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.low);
//
//       latitude = userPosition.latitude;
//       longitude = userPosition.longitude;
//       return await Geolocator.getCurrentPosition();
//     } catch (exception) {
//       print(exception);
//     }
//   }
// }
import 'package:geolocator/geolocator.dart';

class UserLocation {
  double? latitude;
  double? longitude;

  Future<void> getLocation() async {
    try {
      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // Request permission if not already granted
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw Exception('Location permission denied');
        }
      }

      // Get current position
      Position userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      latitude = userPosition.latitude;
      longitude = userPosition.longitude;
    } catch (exception) {
      print('Error fetching location: $exception');
      rethrow; // Optionally rethrow for higher-level handling
    }
  }
}

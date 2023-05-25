import 'package:location/location.dart';

class LocationProvider {
  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    return await location.getLocation();
  }
}

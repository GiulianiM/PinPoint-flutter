import 'package:location/location.dart';

class LocationProvider {
  Location location = Location();

  LocationData? getCurrentLocation() {
    LocationData? currentLocation;

    location.getLocation().then((actual) => currentLocation = actual);
    return currentLocation;
  }
}

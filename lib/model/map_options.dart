import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOptions {
  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  static const MarkerId markerId = MarkerId('current_location');
  static const BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  static const double markerSize = 50.0;
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  final LatLng target;
  final Set<Marker> markers;

  const GoogleMapWidget({
    required this.target,
    required this.markers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: target,
        zoom: 18,
      ),
      onMapCreated: (mapController) {
        // ...
      },
      markers: markers,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
    );
  }
}

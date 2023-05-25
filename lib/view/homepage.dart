import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pinpoint/utils/location.dart';
import 'package:pinpoint/viewmodel/homepage_viewmodel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late GoogleMapController mapController;
  late MapViewModel mapViewModel;
  late LocationProvider location;
  late LocationData? currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    mapViewModel = MapViewModel();
    location = LocationProvider();
    currentLocation = location.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                zoom: 14.4746,
              ),
              //markers: _createMarkers(),
              markers: {
                Marker(
                  markerId: const MarkerId('1'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  anchor: const Offset(0.5, 0.5),
                  zIndex: 2,
                  infoWindow: const InfoWindow(title: 'Posizione attuale'),
                ),
              },
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: true, // Abilita i controlli di zoom
              compassEnabled: true, // Abilita la bussola
              myLocationButtonEnabled:
                  true, // Abilita il pulsante per centrare sulla posizione attuale
              myLocationEnabled:
                  true, // Abilita la visualizzazione della posizione attuale
              tiltGesturesEnabled: true, // Abilita i gesti di tilt
              rotateGesturesEnabled: true, // Abilita i gesti di rotazione
            ),
    ));
  }

  // Set<Marker> _createMarkers() {
  //   final markers = <Marker>{};

  //   Marker marker = const Marker(
  //     markerId: ,
  //     icon: ,
  //     position: LatLng(0, 0),
  //     anchor: Offset(0.5, 0.5),
  //     zIndex: 2,
  //     infoWindow: InfoWindow(title: 'Posizione attuale'),
  //   );

  //   markers.add(marker);

  //   return markers;
  // }
}

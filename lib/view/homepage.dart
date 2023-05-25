import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:pinpoint/viewmodel/homepage_viewmodel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> _controller = Completer();
  late MapViewModel mapViewModel;
  LocationData? currentLocation;
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Location location = Location();

  void checkLocationPermissions() async {
    Location location = Location();
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getCurrentLocation();
    } else if (permissionStatus == PermissionStatus.deniedForever) {
      showPermissionDeniedDialog();
    } else {
      PermissionStatus requestedPermissionStatus =
          await location.requestPermission();
      if (requestedPermissionStatus == PermissionStatus.granted) {
        getCurrentLocation();
      } else {
        // Permessi negati, impostare la posizione di default ad Ancona
        setState(() {
          currentLocation = LocationData.fromMap({
            'latitude': 43.6168,
            'longitude': 13.5189,
          });
        });
      }
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permessi di localizzazione'),
          content: const Text(
              'I permessi di localizzazione sono stati negati. Abilita la localizzazione nelle impostazioni dell\'app.'),
          actions: [
            TextButton(
              child: const Text('Apri Impostazioni'),
              onPressed: () {
                permission_handler.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void getCurrentLocation() async {
    location.getLocation().then((that) {
      setState(() {
        currentLocation = that;
      });
    });

    GoogleMapController mapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) {
      //   mapController.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(
      //         target: LatLng(
      //           newLocation.latitude!,
      //           newLocation.longitude!,
      //         ),
      //         zoom: 18,
      //       ),
      //     ),
      //   );

      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  @override
  void initState() {
    mapViewModel = MapViewModel();
    checkLocationPermissions();
    super.initState();
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
                zoom: 18,
              ),
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              zoomControlsEnabled: false,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
            ),
    ));
  }
}

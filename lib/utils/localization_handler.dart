import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:pinpoint/utils/constants.dart';

import '../repo/database_queries.dart';

class LocalizationHandler {
  BuildContext? _context;

  LocalizationHandler(BuildContext context) {
    _context = context;
  }

  Future<void> checkLocationPermissions(Function(LocationData?) onLocationData) async {
    Location location = Location();
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getCurrentLocation(onLocationData);
    } else if (permissionStatus == PermissionStatus.deniedForever) {
      showPermissionDeniedDialog();
    } else {
      PermissionStatus requestedPermissionStatus = await location.requestPermission();
      if (requestedPermissionStatus == PermissionStatus.granted) {
        getCurrentLocation(onLocationData);
      } else {
        // Permessi negati, impostare la posizione di default ad Ancona
        onLocationData(
          LocationData.fromMap({
            'latitude': double.parse(Constants.defaultLatitude),
            'longitude': double.parse(Constants.defaultLongitude),
          }),
        );
      }
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: _context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permessi di localizzazione'),
          content: const Text(
            'I permessi di localizzazione sono stati negati. Abilita la localizzazione nelle impostazioni dell\'app.',
          ),
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

  void getCurrentLocation(Function(LocationData?) onLocationData) async {
    Location location = Location();
    LocationData? currentLocation;
    try {
      currentLocation = await location.getLocation();
      location.onLocationChanged.listen((newLocation) {
        DatabaseQueries().setNewLocation(newLocation);
        onLocationData(newLocation);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showPermissionDeniedDialog();
      }
      currentLocation = null;
    }
    onLocationData(currentLocation);
  }
}


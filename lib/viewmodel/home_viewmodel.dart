import 'dart:async';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinpoint/utils/constants.dart';

import '../model/utente.dart';

class HomeViewModel with ChangeNotifier {

  Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  void updateMarkers(List<Utente> userList) async {
    final List<Marker> updatedMarkers = await Future.wait(
      userList.map((user) async {
        return Marker(
          markerId: MarkerId(user.uid ?? ''),
          position: LatLng(
            double.parse(user.latitude ?? Constants.defaultLatitude),
            double.parse(user.longitude ?? Constants.defaultLongitude),
          ),
          icon: await MarkerIcon.downloadResizePictureCircle(
            user.image ?? Constants.defaultIcon,
            size: 150,
            addBorder: true,
            borderColor: Colors.blue,
            borderSize: 15,
          ),
          infoWindow: InfoWindow(
            title: user.username ?? '',
          ),
        );
      }),
    );

    _markers = updatedMarkers.toSet();
    notifyListeners();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinpoint/model/map_options.dart';
import 'package:pinpoint/viewmodel/homepage_viewmodel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late GoogleMapController mapController;
  late MapViewModel mapViewModel;
  late CameraPosition _initialCameraPosition = MapOptions.initialPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    mapViewModel = MapViewModel();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    await Geolocator.requestPermission();

    await mapViewModel.getCurrentLocation();

    setState(() {
      _initialCameraPosition = CameraPosition(
        target: LatLng(
          mapViewModel.currentPosition?.latitude ?? 0.0,
          mapViewModel.currentPosition?.longitude ?? 0.0,
        ),
        zoom: 11.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: _initialCameraPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              //markers: _createMarkers(),
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

  Set<Marker> _createMarkers() {
    final markers = <Marker>{};

    Marker marker = const Marker(
      markerId: MapOptions.markerId,
      icon: MapOptions.markerIcon,
      position: LatLng(0, 0),
      anchor: Offset(0.5, 0.5),
      zIndex: 2,
      infoWindow: InfoWindow(title: 'Posizione attuale'),
    );

    markers.add(marker);

    return markers;
  }
}

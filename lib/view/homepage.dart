import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pinpoint/repo/database_queries.dart';

import '../model/utente.dart';
import '../utils/localization_handler.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widget/googlemap_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late HomeViewModel _viewModel;
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  Location location = Location();
  DatabaseQueries databaseQueries = DatabaseQueries();
  StreamSubscription<LocationData>? locationSubscription;
  StreamSubscription<List<Utente>>? userListSubscription;
  late LocalizationHandler _localizationHandler;

  @override
  void initState() {
    _viewModel = HomeViewModel();
    _localizationHandler = LocalizationHandler(context);
    _localizationHandler.checkLocationPermissions((locationData) {
      setState(() {
        currentLocation = locationData;
      });
    });
    userListSubscription = databaseQueries.getAllUsersExceptMeStream().listen((userList) {
      _viewModel.updateMarkers(userList);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentLocation == null
            ? const Center(child: CircularProgressIndicator())
            : currentLocation == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMapWidget(
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          markers: _viewModel.markers,
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    locationSubscription = location.onLocationChanged.listen((newLocation) {
      databaseQueries.setNewLocation(newLocation);
      if (mounted) {
        setState(() {
          currentLocation = newLocation;
          updateCameraPosition(newLocation);
        });
      }
    });

    LocationData? initialLocation = await location.getLocation();
    if (mounted) {
      setState(() {
        currentLocation = initialLocation;
        updateCameraPosition(initialLocation);
      });
    }
  }

  void updateCameraPosition(LocationData? locationData) async {
    if (locationData != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(locationData.latitude!, locationData.longitude!),
      ));
    }
  }


  @override
  void dispose() {
    userListSubscription?.cancel();
    _viewModel.dispose();
    super.dispose();
  }
}

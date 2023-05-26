import 'dart:async';
import 'dart:typed_data';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:pinpoint/repo/database_queries.dart';
import 'package:pinpoint/viewmodel/homepage_viewmodel.dart';

import '../model/utente.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> _controller = Completer();
  final defaultLatitude = "43.6168";
  final defaultLongitude = "13.5189";
  late MapViewModel mapViewModel;
  LocationData? currentLocation;
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Location location = Location();
  DatabaseQueries databaseQueries = DatabaseQueries();
  Set<Marker> markers = {};
  Uint8List? markerIcon;
  StreamSubscription<LocationData>? locationSubscription;

  Future<void> updateMarkers(List<Utente> userList) async {
    const String defaultIcon =
        'https://firebasestorage.googleapis.com/v0/b/pinpointmvvm.appspot.com/o/Default%20Images%2FProfilePicture.png?alt=media&token=780391e3-37ee-4352-8367-f4c08b0f809d';

    final List<Marker> updatedMarkers = await Future.wait(
      userList.map((user) async {
        return Marker(
          markerId: MarkerId(user.uid ?? ''),
          position: LatLng(
            double.parse(user.latitude ?? defaultLatitude),
            double.parse(user.longitude ?? defaultLongitude),
          ),
          icon: await MarkerIcon.downloadResizePictureCircle(
            user.image ?? defaultIcon,
            size: 120,
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

    setState(() {
      markers = updatedMarkers.toSet();
    });
  }

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
            'latitude': double.parse(defaultLatitude),
            'longitude': double.parse(defaultLongitude),
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
      if (mounted) {
        // Controlla se il widget è ancora montato
        setState(() {
          currentLocation = that;
        });
      }
    });

    GoogleMapController mapController = await _controller.future;

    locationSubscription = location.onLocationChanged.listen((newLocation) {
      if (mounted) {
        // Controlla se il widget è ancora montato
        setState(() {
          currentLocation = newLocation;
        });
      }
    });
  }

  /*void getCurrentLocation() async {
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
*/
  @override
  void initState() {
    databaseQueries.getAllUsersExceptMe().then((userList) {
      updateMarkers(userList);
    });
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
              markers: markers,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
            ),
    ));
  }

  @override
  void dispose() {
    locationSubscription
        ?.cancel(); // Annulla l'ascolto dell'evento onLocationChanged
    super.dispose();
  }
}

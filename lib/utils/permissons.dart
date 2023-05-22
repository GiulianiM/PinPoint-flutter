import 'package:permission_handler/permission_handler.dart';

class Permissions {
//Gestisce la richiesta dei permessi
  Future<void> requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var locationStatus = await Permission.locationWhenInUse.request();

    if (cameraStatus.isGranted && locationStatus.isGranted) {
     
    } else if(cameraStatus.isDenied || locationStatus.isDenied) {
      
    } else if(cameraStatus.isPermanentlyDenied || locationStatus.isPermanentlyDenied){
      
    }
  }

  void checkLocationPermissionStatus() async {
  final PermissionStatus status = await Permission.locationWhenInUse.status;
  if (status.isGranted) {
  
  } else {
    
  }
}

}



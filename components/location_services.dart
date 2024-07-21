import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '/_libraries/geocoding/models/coordinates.dart';

mixin LocationServices {
  Future<Position> currentPosition() async {
    Position? position;

    try {
      position = await Geolocator.getCurrentPosition();
    } on LocationServiceDisabledException {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    } on PermissionDeniedException {
      final permission = await Geolocator.requestPermission();
      switch (permission) {
        case LocationPermission.denied:
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');

        case LocationPermission.deniedForever:
          // Permissions are denied forever, handle appropriately.
          return Future.error(
            'Location permissions are permanently denied, please allow from settings.',
          );

        case LocationPermission.always:
        case LocationPermission.whileInUse:
          position = await Geolocator.getCurrentPosition();
          break;

        default:
          return Future.error('Location permissions not allowed');
      }
    }

    return position;
  }

  Future<bool> isLocationAccessEnabled() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      return checkStatus(await Geolocator.checkPermission(), retry: true);
    }
    return false;
  }

  FutureOr<bool> checkStatus(
    LocationPermission status, {
    bool retry = false,
  }) async {
    switch (status) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return true;
      case LocationPermission.deniedForever:
        permissionDeniedForever(openAppSettings);
        return false;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        if (retry) {
          status = await Geolocator.requestPermission();
          return checkStatus(status);
        } else {
          return false;
        }
    }
  }

  void permissionDeniedForever(void Function() openAppSettings);
}

extension ExtendedPosition on Position {
  Coordinates get coordinates =>
      Coordinates(latitude: latitude, longitude: longitude);
}

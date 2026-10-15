import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionsHandler {
  Future<PermissionStatus> checkStatus(Permission permission) async {
    return await permission.status;
  }

  Future<PermissionStatus> requestPermission(
    Permission permission, {
    FutureOr<void>? Function()? onGranted,
    FutureOr<void>? Function()? onDenied,
    FutureOr<void>? Function()? onPermanentlyDenied,
    FutureOr<void>? Function()? onLimited,
    FutureOr<void>? Function()? onProvisional,
    FutureOr<void>? Function()? onRestricted,
  }) async {
    return await permission
        .onGrantedCallback(onGranted)
        .onDeniedCallback(onDenied)
        .onPermanentlyDeniedCallback(onPermanentlyDenied)
        .onLimitedCallback(onLimited)
        .onProvisionalCallback(onProvisional)
        .onRestrictedCallback(onRestricted)
        .request();
  }

  Future<PermissionStatus> checkForegroundLocation() =>
      checkStatus(Permission.locationWhenInUse);

  Future<PermissionStatus> checkBackgroundLocation() =>
      checkStatus(Permission.locationAlways);

  Future<ServiceStatus> checkLocationServiceStatus() =>
      Permission.locationWhenInUse.serviceStatus;

  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}

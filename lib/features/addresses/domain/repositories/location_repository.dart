import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';

abstract interface class LocationRepository {
  Future<PermissionStatusEntity> checkLocationPermission();

  Future<PermissionStatusEntity> requestLocationPermission();

  Future<ServiceStatusEntity> checkLocationService();

  Future<bool> requestLocationService();

  Future<bool> openAppSettings();

  Future<BaseResponse<String?>> getAddressFromLocation(
    CoordinatesEntity location,
  );

  Future<BaseResponse<(CoordinatesEntity, String?)>> fetchUserCurrentLocation();
}

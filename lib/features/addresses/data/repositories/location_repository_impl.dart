import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/features/addresses/data/mappers/permission_status_mapper.dart';
import 'package:flowrist/features/addresses/data/mappers/service_status_mapper.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data_sources/location_service.dart';
import '../data_sources/permission_handler.dart';

@Injectable(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final PermissionsHandler _permissionsHandler;
  final LocationService _locationService;

  LocationRepositoryImpl(this._permissionsHandler, this._locationService);

  @override
  Future<PermissionStatusEntity> checkLocationPermission() async {
    final status = await _permissionsHandler.checkForegroundLocation();
    return status.toEntity();
  }

  @override
  Future<PermissionStatusEntity> requestLocationPermission() async {
    final status = await _permissionsHandler.requestPermission(
      Permission.locationWhenInUse,
    );
    return status.toEntity();
  }

  @override
  Future<ServiceStatusEntity> checkLocationService() async {
    final status = await _permissionsHandler.checkLocationServiceStatus();
    return status.toEntity();
  }

  @override
  Future<bool> requestLocationService() async {
    return await _locationService.requestLocationService();
  }

  @override
  Future<bool> openAppSettings() async {
    return await _permissionsHandler.openSettings();
  }

  @override
  Future<BaseResponse<String?>> getAddressFromLocation(
    CoordinatesEntity location,
  ) async {
    try {
      final locations = await _locationService.getAddressesFromCoordinates(
        lat: location.latitude,
        long: location.longitude,
      );

      if (locations.isEmpty) {
        return ErrorResponse<String?>(AppStrings.addressNotFoundMessage);
      }

      final street = _locationService.formatAddress(locations[0]);

      if (street.isEmpty) {
        return ErrorResponse<String?>(AppStrings.addressNotFoundMessage);
      }

      return SuccessResponse<String?>(street);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<String?>(e);
    }
  }

  @override
  Future<BaseResponse<(CoordinatesEntity, String?)>>
  fetchUserCurrentLocation() async {
    try {
      final locationData = await _locationService.fetchUserCurrentLocation();
      final location = CoordinatesEntity(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
      final response = await getAddressFromLocation(location);

      if (response is SuccessResponse<String?>) {
        return SuccessResponse<(CoordinatesEntity, String?)>((
          location,
          response.data,
        ));
      } else if (response is ErrorResponse<String?>) {
        return ErrorResponse<(CoordinatesEntity, String?)>(
          response.errorMessage,
        );
      }
      return ErrorResponse<(CoordinatesEntity, String?)>(
        AppStrings.generalErrorMessage,
      );
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<(CoordinatesEntity, String?)>(e);
    }
  }
}


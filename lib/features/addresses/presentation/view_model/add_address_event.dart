import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';

sealed class AddAddressEvent {}

class CheckLocationPermission extends AddAddressEvent {}

class RequestLocationPermission extends AddAddressEvent {}

class CheckLocationService extends AddAddressEvent {}

class RequestLocationService extends AddAddressEvent {}

class OpenAppSettings extends AddAddressEvent {}

class FetchUserLocation extends AddAddressEvent {}

class SelectMapLocation extends AddAddressEvent {
  final CoordinatesEntity location;

  SelectMapLocation(this.location);
}

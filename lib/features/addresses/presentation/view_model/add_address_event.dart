import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';

import '../../../../shared/domain/entities/city_entity.dart';
import '../../../../shared/domain/entities/governorate_entity.dart';
import '../../data/models/add_address_request_model.dart';

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

class GetGovernoratesEvent extends AddAddressEvent {}

class GetCitiesEvent extends AddAddressEvent {
  final int governorateId;

  GetCitiesEvent(this.governorateId);
}

class SelectGovernorateEvent extends AddAddressEvent {
  final GovernorateEntity governorate;

  SelectGovernorateEvent(this.governorate);
}

class SelectCityEvent extends AddAddressEvent {
  final CityEntity city;

  SelectCityEvent(this.city);
}

class SaveAddressEvent extends AddAddressEvent {
  final AddAddressRequestModel request;

  SaveAddressEvent(this.request);
}

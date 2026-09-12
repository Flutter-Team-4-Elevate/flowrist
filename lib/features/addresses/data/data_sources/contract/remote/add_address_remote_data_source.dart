import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/data/models/get_cities_response_model.dart';
import 'package:flowrist/features/addresses/data/models/get_governorates_response_model.dart';

abstract interface class AddAddressRemoteDataSource {
  Future<GetGovernoratesResponseModel> getGovernorates();

  Future<GetCitiesResponseModel> getCities(int governorateId);

  Future<void> saveAddress(AddAddressRequestModel request);
}

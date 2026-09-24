import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/data/models/get_cities_response_model.dart';
import 'package:flowrist/features/addresses/data/models/get_governorates_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../../api_client/add_address_api_client.dart';
import '../../contract/remote/add_address_remote_data_source.dart';

@Injectable(as: AddAddressRemoteDataSource)
class AddAddressRemoteDataSourceImpl implements AddAddressRemoteDataSource {
  final AddAddressApiClient _apiClient;

  AddAddressRemoteDataSourceImpl(this._apiClient);

  @override
  Future<GetGovernoratesResponseModel> getGovernorates() {
    return _apiClient.getGovernorates();
  }

  @override
  Future<GetCitiesResponseModel> getCities(int governorateId) {
    return _apiClient.getCities(governorateId);
  }

  @override
  Future<void> saveAddress(AddAddressRequestModel request) {
    return _apiClient.saveAddress(request);
  }

  @override
  Future<void> updateAddress(String addressId, AddAddressRequestModel request) {
    return _apiClient.updateAddress(addressId, request);
  }
}

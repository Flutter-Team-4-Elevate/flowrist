import '../../../../config/base_response/base_response.dart';
import '../../data/models/add_address_request_model.dart';
import '../entities/city_entity.dart';
import '../entities/governorate_entity.dart';

abstract interface class AddAddressRepository {
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates();

  Future<BaseResponse<List<CityEntity>>> getCities(int governorateId);

  Future<BaseResponse<void>> saveAddress(AddAddressRequestModel request);

  Future<BaseResponse<void>> updateAddress(
    String addressId,
    AddAddressRequestModel request,
  );
}

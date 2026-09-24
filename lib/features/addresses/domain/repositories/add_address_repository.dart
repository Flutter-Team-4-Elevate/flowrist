import '../../../../config/base_response/base_response.dart';
import '../../../../shared/domain/entities/city_entity.dart';
import '../../../../shared/domain/entities/governorate_entity.dart';
import '../../data/models/add_address_request_model.dart';

abstract interface class AddAddressRepository {
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates();

  Future<BaseResponse<List<CityEntity>>> getCities(int governorateId);

  Future<BaseResponse<void>> saveAddress(AddAddressRequestModel request);

  Future<BaseResponse<void>> updateAddress(
    String addressId,
    AddAddressRequestModel request,
  );
}

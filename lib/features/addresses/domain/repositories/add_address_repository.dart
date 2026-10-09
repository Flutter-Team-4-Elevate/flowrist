import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/domain/entities/add_address_request_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/city_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/governorate_entity.dart';

abstract interface class AddAddressRepository {
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates();

  Future<BaseResponse<List<CityEntity>>> getCities(int governorateId);

  Future<BaseResponse<void>> saveAddress(AddAddressRequestEntity request);

  Future<BaseResponse<void>> updateAddress(
    String addressId,
    AddAddressRequestEntity request,
  );
}

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';

abstract interface class AddressesRepository {
  Future<BaseResponse<List<AddressEntity>>> getAllUserAddresses();

  Future<BaseResponse<DefaultAddressEntity>> setDefaultAddress(
    String addressId,
  );

  Future<BaseResponse<String>> deleteAddress(String addressId,);
}

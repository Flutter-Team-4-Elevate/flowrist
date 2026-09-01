import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/data/models/address_model.dart';

import '../../../models/default_address_response_model.dart';

abstract interface class AddressesRemoteDataSource {
  Future<BaseResponse<List<AddressModel>>> getAllUserAddresses();

  Future<BaseResponse<DefaultAddressResponseModel>> setDefaultAddress(
    String addressId,
  );

  Future<BaseResponse<String>> deleteAddress(String addressId,);
}

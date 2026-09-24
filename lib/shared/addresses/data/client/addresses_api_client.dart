import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/shared/addresses/data/models/address_api_response_model.dart';
import 'package:flowrist/shared/addresses/data/models/delete_address_response_model.dart';
import 'package:flowrist/shared/addresses/data/models/set_default_address_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'addresses_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AddressesApiClient {
  @factoryMethod
  factory AddressesApiClient(Dio dio) = _AddressesApiClient;

  @GET(Endpoints.getAllAddress)
  Future<AddressApiResponseModel> getAllUserAddresses();

  @PATCH(Endpoints.setDefaultAddress)
  Future<SetDefaultAddressResponseModel> setDefaultAddress(
    @Path(Endpoints.addressId) String addressId,
  );

  @DELETE(Endpoints.deleteAddress)
  Future<DeleteAddressResponseModel> deleteAddress(
    @Path(Endpoints.addressId) String addressId,
  );
}

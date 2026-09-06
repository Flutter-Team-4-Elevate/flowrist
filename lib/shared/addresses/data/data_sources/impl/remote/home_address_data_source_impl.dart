import 'package:dio/dio.dart';
import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/data/client/addresses_api_client.dart';
import 'package:flowrist/shared/addresses/data/data_sources/contract/remote/home_address_data_source.dart';
import 'package:flowrist/shared/addresses/data/models/address_model.dart';
import 'package:injectable/injectable.dart';

import '../../../models/default_address_response_model.dart';

@Injectable(as: AddressesRemoteDataSource)
class AddressRemoteDataSourceImpl implements AddressesRemoteDataSource {
  final AddressesApiClient _apiClient;

  AddressRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<List<AddressModel>>> getAllUserAddresses() async {
    try {
      final response = await _apiClient.getAllUserAddresses();

      return SuccessResponse(response.data ?? []);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<AddressModel>>(e);
    }
  }

  @override
  Future<BaseResponse<DefaultAddressResponseModel>> setDefaultAddress(
    String addressId,
  ) async {
    try {
      final response = await _apiClient.setDefaultAddress(addressId);

      if (response.status && response.data != null) {
        return SuccessResponse<DefaultAddressResponseModel>(response.data!);
      }

      return ErrorResponse<DefaultAddressResponseModel>(response.message);
    } on DioException catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }

  @override
  Future<BaseResponse<String>> deleteAddress(String addressId,) async {
    try {
      final response = await _apiClient.deleteAddress(addressId);

      if (response.status) {
        return SuccessResponse<String>(response.message);
      }

      return ErrorResponse<String>(response.message);
    } on DioException catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }
}

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/data/data_sources/contract/remote/home_address_data_source.dart';
import 'package:flowrist/shared/addresses/data/models/address_model.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/repositories/addresses_repository.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/default_address_entity.dart';
import '../models/default_address_response_model.dart';

@Injectable(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource _remoteDataSource;

  AddressesRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<AddressEntity>>> getAllUserAddresses() async {
    final response = await _remoteDataSource.getAllUserAddresses();

    switch (response) {
      case SuccessResponse<List<AddressModel>>():
        return SuccessResponse(
          response.data?.map((e) => e.toEntity()).toList() ?? [],
        );
      case ErrorResponse<List<AddressModel>>():
        return ErrorResponse(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<DefaultAddressEntity>> setDefaultAddress(
    String addressId,
  ) async {
    final response = await _remoteDataSource.setDefaultAddress(addressId);

    switch (response) {
      case SuccessResponse<DefaultAddressResponseModel>():
        return SuccessResponse(response.data?.toEntity());

      case ErrorResponse<DefaultAddressResponseModel>():
        return ErrorResponse(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<String>> deleteAddress(String addressId) async {
    final response = await _remoteDataSource.deleteAddress(addressId);

    switch (response) {
      case SuccessResponse<String>():
        return SuccessResponse(response.data);

      case ErrorResponse<String>():
        return ErrorResponse(response.errorMessage);
    }
  }
}

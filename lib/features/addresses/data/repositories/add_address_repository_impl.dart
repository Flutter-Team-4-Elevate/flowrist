import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:flowrist/shared/domain/entities/governorate_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/add_address_repository.dart';
import '../data_sources/contract/remote/add_address_remote_data_source.dart';
import '../models/add_address_request_model.dart';

@Injectable(as: AddAddressRepository)
class AddAddressRepositoryImpl implements AddAddressRepository {
  final AddAddressRemoteDataSource _remoteDataSource;

  AddAddressRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates() async {
    try {
      final models = await _remoteDataSource.getGovernorates();
      final entities = models.data?.map((m) => m.toEntity()).toList();
      return SuccessResponse(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<GovernorateEntity>>(e);
    }
  }

  @override
  Future<BaseResponse<List<CityEntity>>> getCities(int governorateId) async {
    try {
      final models = await _remoteDataSource.getCities(governorateId);
      final entities = models.data?.map((m) => m.toEntity()).toList();
      return SuccessResponse(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<CityEntity>>(e);
    }
  }

  @override
  Future<BaseResponse<void>> saveAddress(AddAddressRequestModel request) async {
    try {
      await _remoteDataSource.saveAddress(request);
      return SuccessResponse(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateAddress(
    String addressId,
    AddAddressRequestModel request,
  ) async {
    try {
      await _remoteDataSource.updateAddress(addressId, request);
      return SuccessResponse(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    }
  }
}

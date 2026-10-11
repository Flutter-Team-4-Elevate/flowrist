import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/data/data_sources/contract/remote/add_address_remote_data_source.dart';
import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/domain/entities/add_address_request_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/city_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/governorate_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/add_address_repository.dart';
import 'package:injectable/injectable.dart';

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
  Future<BaseResponse<void>> saveAddress(AddAddressRequestEntity request) async {
    try {
      await _remoteDataSource.saveAddress(request.toModel());
      return SuccessResponse(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateAddress(
    String addressId,
    AddAddressRequestEntity request,
  ) async {
    try {
      await _remoteDataSource.updateAddress(addressId, request.toModel());
      return SuccessResponse(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    }
  }
}

extension AddAddressRequestEntityX on AddAddressRequestEntity {
  AddAddressRequestModel toModel() {
    return AddAddressRequestModel(
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      addressLine: addressLine,
      governorateId: governorateId,
      cityId: cityId,
      area: area,
      lat: lat,
      lng: lng,
      label: label,
    );
  }
}

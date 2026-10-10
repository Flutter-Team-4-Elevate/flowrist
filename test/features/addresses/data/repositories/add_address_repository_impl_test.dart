import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/data/data_sources/contract/remote/add_address_remote_data_source.dart';
import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/data/models/city_model.dart';
import 'package:flowrist/features/addresses/data/models/get_cities_response_model.dart';
import 'package:flowrist/features/addresses/data/models/get_governorates_response_model.dart';
import 'package:flowrist/features/addresses/data/models/governorate_model.dart';
import 'package:flowrist/features/addresses/data/repositories/add_address_repository_impl.dart';
import 'package:flowrist/features/addresses/domain/entities/add_address_request_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/city_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/governorate_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_address_repository_impl_test.mocks.dart';

@GenerateMocks([AddAddressRemoteDataSource])
void main() {
  provideDummy<GetGovernoratesResponseModel>(
    const GetGovernoratesResponseModel(),
  );
  provideDummy<GetCitiesResponseModel>(
    const GetCitiesResponseModel(),
  );

  late MockAddAddressRemoteDataSource mockRemoteDataSource;
  late AddAddressRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAddAddressRemoteDataSource();
    repository = AddAddressRepositoryImpl(mockRemoteDataSource);
  });

  final tGovernorateModel = GovernorateModel(
    id: 1,
    nameAr: 'القاهرة',
    nameEn: 'Cairo',
  );

  final tCityModel = CityModel(
    id: 1,
    governorateId: 1,
    nameAr: 'المعادي',
    nameEn: 'Maadi',
  );

  const tRequestEntity = AddAddressRequestEntity(
    recipientName: 'John Doe',
    recipientPhone: '0123456789',
    addressLine: '123 Main St',
    governorateId: 1,
    cityId: 1,
    area: 'Maadi',
    lat: 30.0444,
    lng: 31.2357,
    label: 'home',
  );

  group('getGovernorates', () {
    test(
      'should return SuccessResponse with mapped GovernorateEntity list when datasource succeeds',
      () async {
        // Arrange
        final responseModel = GetGovernoratesResponseModel(
          status: true,
          code: 200,
          data: [tGovernorateModel],
        );
        when(mockRemoteDataSource.getGovernorates()).thenAnswer(
          (_) async => responseModel,
        );

        // Act
        final result = await repository.getGovernorates();

        // Assert
        expect(result, isA<SuccessResponse<List<GovernorateEntity>>>());
        final success = result as SuccessResponse<List<GovernorateEntity>>;
        expect(success.data, isNotNull);
        expect(success.data!.length, 1);
        expect(success.data![0].id, tGovernorateModel.id);
        expect(success.data![0].nameEn, tGovernorateModel.nameEn);
        expect(success.data![0].nameAr, tGovernorateModel.nameAr);
        verify(mockRemoteDataSource.getGovernorates()).called(1);
      },
    );

    test(
      'should return ErrorResponse when datasource throws an Exception',
      () async {
        // Arrange
        when(mockRemoteDataSource.getGovernorates()).thenThrow(
          Exception('Network failure'),
        );

        // Act
        final result = await repository.getGovernorates();

        // Assert
        expect(result, isA<ErrorResponse<List<GovernorateEntity>>>());
        verify(mockRemoteDataSource.getGovernorates()).called(1);
      },
    );
  });

  group('getCities', () {
    const tGovernorateId = 1;

    test(
      'should return SuccessResponse with mapped CityEntity list when datasource succeeds',
      () async {
        // Arrange
        final responseModel = GetCitiesResponseModel(
          status: true,
          code: 200,
          data: [tCityModel],
        );
        when(mockRemoteDataSource.getCities(tGovernorateId)).thenAnswer(
          (_) async => responseModel,
        );

        // Act
        final result = await repository.getCities(tGovernorateId);

        // Assert
        expect(result, isA<SuccessResponse<List<CityEntity>>>());
        final success = result as SuccessResponse<List<CityEntity>>;
        expect(success.data, isNotNull);
        expect(success.data!.length, 1);
        expect(success.data![0].id, tCityModel.id);
        expect(success.data![0].governorateId, tCityModel.governorateId);
        expect(success.data![0].nameEn, tCityModel.nameEn);
        expect(success.data![0].nameAr, tCityModel.nameAr);
        verify(mockRemoteDataSource.getCities(tGovernorateId)).called(1);
      },
    );

    test(
      'should return ErrorResponse when datasource throws an Exception',
      () async {
        // Arrange
        when(mockRemoteDataSource.getCities(tGovernorateId)).thenThrow(
          Exception('Server error'),
        );

        // Act
        final result = await repository.getCities(tGovernorateId);

        // Assert
        expect(result, isA<ErrorResponse<List<CityEntity>>>());
        verify(mockRemoteDataSource.getCities(tGovernorateId)).called(1);
      },
    );
  });

  group('saveAddress', () {
    test(
      'should call remoteDataSource.saveAddress with converted model and return SuccessResponse',
      () async {
        // Arrange
        when(mockRemoteDataSource.saveAddress(any)).thenAnswer((_) async {});

        // Act
        final result = await repository.saveAddress(tRequestEntity);

        // Assert
        expect(result, isA<SuccessResponse<void>>());
        final captured = verify(
          mockRemoteDataSource.saveAddress(captureThat(isA<AddAddressRequestModel>())),
        ).captured;
        final savedModel = captured.first as AddAddressRequestModel;
        expect(savedModel.recipientName, tRequestEntity.recipientName);
        expect(savedModel.recipientPhone, tRequestEntity.recipientPhone);
        expect(savedModel.addressLine, tRequestEntity.addressLine);
        expect(savedModel.governorateId, tRequestEntity.governorateId);
        expect(savedModel.cityId, tRequestEntity.cityId);
        expect(savedModel.area, tRequestEntity.area);
        expect(savedModel.lat, tRequestEntity.lat);
        expect(savedModel.lng, tRequestEntity.lng);
        expect(savedModel.label, tRequestEntity.label);
      },
    );

    test(
      'should return ErrorResponse when remoteDataSource.saveAddress throws an Exception',
      () async {
        // Arrange
        when(mockRemoteDataSource.saveAddress(any)).thenThrow(
          Exception('Failed to save address'),
        );

        // Act
        final result = await repository.saveAddress(tRequestEntity);

        // Assert
        expect(result, isA<ErrorResponse<void>>());
      },
    );
  });

  group('updateAddress', () {
    const tAddressId = 'address_123';

    test(
      'should call remoteDataSource.updateAddress with converted model and return SuccessResponse',
      () async {
        // Arrange
        when(mockRemoteDataSource.updateAddress(tAddressId, any)).thenAnswer((_) async {});

        // Act
        final result = await repository.updateAddress(tAddressId, tRequestEntity);

        // Assert
        expect(result, isA<SuccessResponse<void>>());
        final captured = verify(
          mockRemoteDataSource.updateAddress(
            tAddressId,
            captureThat(isA<AddAddressRequestModel>()),
          ),
        ).captured;
        final updatedModel = captured.first as AddAddressRequestModel;
        expect(updatedModel.recipientName, tRequestEntity.recipientName);
        expect(updatedModel.recipientPhone, tRequestEntity.recipientPhone);
        expect(updatedModel.addressLine, tRequestEntity.addressLine);
        expect(updatedModel.governorateId, tRequestEntity.governorateId);
        expect(updatedModel.cityId, tRequestEntity.cityId);
        expect(updatedModel.area, tRequestEntity.area);
        expect(updatedModel.lat, tRequestEntity.lat);
        expect(updatedModel.lng, tRequestEntity.lng);
        expect(updatedModel.label, tRequestEntity.label);
      },
    );

    test(
      'should return ErrorResponse when remoteDataSource.updateAddress throws an Exception',
      () async {
        // Arrange
        when(mockRemoteDataSource.updateAddress(tAddressId, any)).thenThrow(
          Exception('Failed to update address'),
        );

        // Act
        final result = await repository.updateAddress(tAddressId, tRequestEntity);

        // Assert
        expect(result, isA<ErrorResponse<void>>());
      },
    );
  });
}

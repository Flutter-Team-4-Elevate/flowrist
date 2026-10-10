import 'package:flowrist/features/addresses/data/api_client/add_address_api_client.dart';
import 'package:flowrist/features/addresses/data/data_sources/impl/remote/add_address_remote_data_source_impl.dart';
import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/data/models/get_cities_response_model.dart';
import 'package:flowrist/features/addresses/data/models/get_governorates_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AddAddressApiClient])
void main() {
  provideDummy<GetGovernoratesResponseModel>(
    const GetGovernoratesResponseModel(),
  );
  provideDummy<GetCitiesResponseModel>(
    const GetCitiesResponseModel(),
  );

  late MockAddAddressApiClient mockApiClient;
  late AddAddressRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockAddAddressApiClient();
    dataSource = AddAddressRemoteDataSourceImpl(mockApiClient);
  });

  final tRequestModel = AddAddressRequestModel(
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
    test('should call apiClient.getGovernorates and return GetGovernoratesResponseModel', () async {
      // Arrange
      const expectedResponse = GetGovernoratesResponseModel(
        status: true,
        code: 200,
      );
      when(mockApiClient.getGovernorates()).thenAnswer(
        (_) async => expectedResponse,
      );

      // Act
      final result = await dataSource.getGovernorates();

      // Assert
      expect(result, equals(expectedResponse));
      verify(mockApiClient.getGovernorates()).called(1);
    });

    test('should rethrow exception when apiClient.getGovernorates fails', () async {
      // Arrange
      when(mockApiClient.getGovernorates()).thenThrow(
        Exception('API Error'),
      );

      // Act & Assert
      expect(
        () => dataSource.getGovernorates(),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.getGovernorates()).called(1);
    });
  });

  group('getCities', () {
    const tGovernorateId = 1;

    test('should call apiClient.getCities and return GetCitiesResponseModel', () async {
      // Arrange
      const expectedResponse = GetCitiesResponseModel(
        status: true,
        code: 200,
      );
      when(mockApiClient.getCities(tGovernorateId)).thenAnswer(
        (_) async => expectedResponse,
      );

      // Act
      final result = await dataSource.getCities(tGovernorateId);

      // Assert
      expect(result, equals(expectedResponse));
      verify(mockApiClient.getCities(tGovernorateId)).called(1);
    });

    test('should rethrow exception when apiClient.getCities fails', () async {
      // Arrange
      when(mockApiClient.getCities(tGovernorateId)).thenThrow(
        Exception('API Error'),
      );

      // Act & Assert
      expect(
        () => dataSource.getCities(tGovernorateId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.getCities(tGovernorateId)).called(1);
    });
  });

  group('saveAddress', () {
    test('should call apiClient.saveAddress with correct request model', () async {
      // Arrange
      when(mockApiClient.saveAddress(tRequestModel)).thenAnswer((_) async {});

      // Act
      await dataSource.saveAddress(tRequestModel);

      // Assert
      verify(mockApiClient.saveAddress(tRequestModel)).called(1);
    });

    test('should rethrow exception when apiClient.saveAddress fails', () async {
      // Arrange
      when(mockApiClient.saveAddress(tRequestModel)).thenThrow(
        Exception('Save Error'),
      );

      // Act & Assert
      expect(
        () => dataSource.saveAddress(tRequestModel),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.saveAddress(tRequestModel)).called(1);
    });
  });

  group('updateAddress', () {
    const tAddressId = 'address_123';

    test('should call apiClient.updateAddress with correct params', () async {
      // Arrange
      when(mockApiClient.updateAddress(tAddressId, tRequestModel)).thenAnswer((_) async {});

      // Act
      await dataSource.updateAddress(tAddressId, tRequestModel);

      // Assert
      verify(mockApiClient.updateAddress(tAddressId, tRequestModel)).called(1);
    });

    test('should rethrow exception when apiClient.updateAddress fails', () async {
      // Arrange
      when(mockApiClient.updateAddress(tAddressId, tRequestModel)).thenThrow(
        Exception('Update Error'),
      );

      // Act & Assert
      expect(
        () => dataSource.updateAddress(tAddressId, tRequestModel),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.updateAddress(tAddressId, tRequestModel)).called(1);
    });
  });
}

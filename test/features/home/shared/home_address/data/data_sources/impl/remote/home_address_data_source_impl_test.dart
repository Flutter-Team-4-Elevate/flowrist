import 'package:dio/dio.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/data/client/addresses_api_client.dart';
import 'package:flowrist/shared/addresses/data/data_sources/impl/remote/home_address_data_source_impl.dart';
import 'package:flowrist/shared/addresses/data/models/address_api_response_model.dart';
import 'package:flowrist/shared/addresses/data/models/address_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_address_data_source_impl_test.mocks.dart';

@GenerateMocks([AddressesApiClient])
void main() {
  late MockAddressesApiClient mockApiClient;
  late AddressRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockAddressesApiClient();
    dataSource = AddressRemoteDataSourceImpl(mockApiClient);
  });

  group('getAllUserAddresses', () {
    test(
      'should return SuccessResponse with addresses when API succeeds',
      () async {
        // Arrange
        final addresses = [
          AddressModel(
            id: 'address-1',
            recipientName: 'Hesham',
            recipientPhone: '01041149296',
            addressLine: 'Helwan Main Street',
            city: 'Helwan',
            area: 'Helwan',
            label: 'home',
            lat: 29.8414,
            lng: 31.3008,
            isDefault: true,
            storeId: null,
            isServiceable: true,
            createdAt: DateTime(2026, 8, 28),
            updatedAt: DateTime(2026, 8, 28),
          ),
          AddressModel(
            id: 'address-2',
            recipientName: 'Hesham',
            recipientPhone: '01041149296',
            addressLine: 'Ain Helwan Street',
            city: 'Helwan',
            area: 'Ain Helwan',
            label: 'work',
            lat: 29.8626,
            lng: 31.3342,
            isDefault: false,
            storeId: null,
            isServiceable: true,
            createdAt: DateTime(2026, 8, 28),
            updatedAt: DateTime(2026, 8, 28),
          ),
        ];

        final response = AddressApiResponseModel(
          status: true,
          code: 200,
          message: 'Addresses retrieved successfully',
          data: addresses,
        );

        when(
          mockApiClient.getAllUserAddresses(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getAllUserAddresses();

        // Assert
        expect(result, isA<SuccessResponse<List<AddressModel>>>());

        final success = result as SuccessResponse<List<AddressModel>>;

        expect(success.data, isNotNull);
        expect(success.data, addresses);
        expect(success.data!.length, 2);

        verify(mockApiClient.getAllUserAddresses()).called(1);
      },
    );

    test(
      'should return SuccessResponse with empty list when API returns empty list',
      () async {
        // Arrange
        final response = AddressApiResponseModel(
          status: true,
          code: 200,
          message: 'Addresses retrieved successfully',
          data: [],
        );

        when(
          mockApiClient.getAllUserAddresses(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getAllUserAddresses();

        // Assert
        expect(result, isA<SuccessResponse<List<AddressModel>>>());

        final success = result as SuccessResponse<List<AddressModel>>;

        expect(success.data, isNotNull);
        expect(success.data, isEmpty);

        verify(mockApiClient.getAllUserAddresses()).called(1);
      },
    );

    test('should return ErrorResponse when API throws DioException', () async {
      // Arrange
      final exception = DioException(
        requestOptions: RequestOptions(path: '/addresses'),
        type: DioExceptionType.connectionError,
        message: 'Connection failed',
      );

      when(mockApiClient.getAllUserAddresses()).thenThrow(exception);

      // Act
      final result = await dataSource.getAllUserAddresses();

      // Assert
      expect(result, isA<ErrorResponse<List<AddressModel>>>());

      final error = result as ErrorResponse<List<AddressModel>>;

      expect(error.errorMessage, isNotEmpty);

      verify(mockApiClient.getAllUserAddresses()).called(1);
    });

    test('should return ErrorResponse when connection times out', () async {
      // Arrange
      final exception = DioException(
        requestOptions: RequestOptions(path: '/addresses'),
        type: DioExceptionType.connectionTimeout,
        message: 'Connection timeout',
      );

      when(mockApiClient.getAllUserAddresses()).thenThrow(exception);

      // Act
      final result = await dataSource.getAllUserAddresses();

      // Assert
      expect(result, isA<ErrorResponse<List<AddressModel>>>());

      final error = result as ErrorResponse<List<AddressModel>>;

      expect(error.errorMessage, isNotEmpty);

      verify(mockApiClient.getAllUserAddresses()).called(1);
    });
  });
}

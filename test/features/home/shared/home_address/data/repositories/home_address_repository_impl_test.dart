import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/data/data_sources/contract/remote/home_address_data_source.dart';
import 'package:flowrist/shared/addresses/data/models/address_model.dart';
import 'package:flowrist/shared/addresses/data/repositories/addresses_repository_impl.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_address_repository_impl_test.mocks.dart';

@GenerateMocks([AddressesRemoteDataSource])
void main() {
  provideDummy<BaseResponse<List<AddressModel>>>(
    SuccessResponse<List<AddressModel>>([]),
  );

  late MockAddressesRemoteDataSource mockRemoteDataSource;
  late AddressesRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAddressesRemoteDataSource();

    repository = AddressesRepositoryImpl(mockRemoteDataSource);
  });

  group('getAllUserAddresses', () {
    test(
      'should return SuccessResponse with mapped AddressEntity list when datasource succeeds',
      () async {
        // Arrange
        final models = [
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

        when(
          mockRemoteDataSource.getAllUserAddresses(),
        ).thenAnswer((_) async => SuccessResponse<List<AddressModel>>(models));

        // Act
        final result = await repository.getAllUserAddresses();

        // Assert
        expect(result, isA<SuccessResponse<List<AddressEntity>>>());

        final success = result as SuccessResponse<List<AddressEntity>>;

        expect(success.data, isNotNull);
        expect(success.data!.length, 2);

        // Verify first entity
        expect(success.data![0].id, models[0].id);
        expect(success.data![0].recipientName, models[0].recipientName);
        expect(success.data![0].recipientPhone, models[0].recipientPhone);
        expect(success.data![0].addressLine, models[0].addressLine);
        expect(success.data![0].city, models[0].city);
        expect(success.data![0].area, models[0].area);
        expect(success.data![0].label, models[0].label);
        expect(success.data![0].lat, models[0].lat);
        expect(success.data![0].lng, models[0].lng);
        expect(success.data![0].isDefault, models[0].isDefault);

        // Verify second entity
        expect(success.data![1].id, models[1].id);
        expect(success.data![1].recipientName, models[1].recipientName);
        expect(success.data![1].isDefault, models[1].isDefault);

        verify(mockRemoteDataSource.getAllUserAddresses()).called(1);
      },
    );

    test(
      'should return SuccessResponse with empty list when datasource returns empty list',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllUserAddresses(),
        ).thenAnswer((_) async => SuccessResponse<List<AddressModel>>([]));

        // Act
        final result = await repository.getAllUserAddresses();

        // Assert
        expect(result, isA<SuccessResponse<List<AddressEntity>>>());

        final success = result as SuccessResponse<List<AddressEntity>>;

        expect(success.data, isEmpty);

        verify(mockRemoteDataSource.getAllUserAddresses()).called(1);
      },
    );

    test(
      'should return SuccessResponse with empty list when datasource returns null data',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllUserAddresses(),
        ).thenAnswer((_) async => SuccessResponse<List<AddressModel>>(null));

        // Act
        final result = await repository.getAllUserAddresses();

        // Assert
        expect(result, isA<SuccessResponse<List<AddressEntity>>>());

        final success = result as SuccessResponse<List<AddressEntity>>;

        expect(success.data, isEmpty);

        verify(mockRemoteDataSource.getAllUserAddresses()).called(1);
      },
    );

    test(
      'should return ErrorResponse when datasource returns ErrorResponse',
      () async {
        // Arrange
        const errorMessage = 'Failed to get user addresses';

        when(mockRemoteDataSource.getAllUserAddresses()).thenAnswer(
          (_) async => ErrorResponse<List<AddressModel>>(errorMessage),
        );

        // Act
        final result = await repository.getAllUserAddresses();

        // Assert
        expect(result, isA<ErrorResponse<List<AddressEntity>>>());

        final error = result as ErrorResponse<List<AddressEntity>>;

        expect(error.errorMessage, errorMessage);

        verify(mockRemoteDataSource.getAllUserAddresses()).called(1);
      },
    );
  });
}

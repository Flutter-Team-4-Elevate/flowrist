import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/data/data_sources/contract/remote/home_address_data_source.dart';
import 'package:flowrist/features/addresses/data/models/address_model.dart';
import 'package:flowrist/features/addresses/data/models/default_address_response_model.dart';
import 'package:flowrist/features/addresses/data/repositories/addresses_repository_impl.dart';
import 'package:flowrist/features/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/default_address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'addresses_repository_impl_test.mocks.dart';

@GenerateMocks([AddressesRemoteDataSource])
void main() {
  provideDummy<BaseResponse<List<AddressModel>>>(
    SuccessResponse<List<AddressModel>>([]),
  );
  provideDummy<BaseResponse<DefaultAddressResponseModel>>(
    SuccessResponse<DefaultAddressResponseModel>(
      DefaultAddressResponseModel(
        addressId: '1',
        isDefault: true,
        updatedAt: DateTime(2026, 1, 1),
      ),
    ),
  );
  provideDummy<BaseResponse<String>>(
    SuccessResponse<String>(''),
  );

  late MockAddressesRemoteDataSource mockRemoteDataSource;
  late AddressesRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAddressesRemoteDataSource();
    repository = AddressesRepositoryImpl(mockRemoteDataSource);
  });

  final tAddressModel = AddressModel(
    id: 'address-1',
    recipientName: 'John Doe',
    recipientPhone: '0123456789',
    addressLine: '123 Main St',
    city: 'Cairo',
    area: 'Maadi',
    label: 'home',
    lat: 30.0444,
    lng: 31.2357,
    isDefault: true,
    isServiceable: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  group('getAllUserAddresses', () {
    test(
      'should return SuccessResponse with mapped AddressEntity list when remoteDataSource succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.getAllUserAddresses()).thenAnswer(
          (_) async => SuccessResponse<List<AddressModel>>([tAddressModel]),
        );

        // Act
        final result = await repository.getAllUserAddresses();

        // Assert
        expect(result, isA<SuccessResponse<List<AddressEntity>>>());
        final success = result as SuccessResponse<List<AddressEntity>>;
        expect(success.data, isNotNull);
        expect(success.data!.length, 1);
        expect(success.data![0].id, tAddressModel.id);
        expect(success.data![0].recipientName, tAddressModel.recipientName);
        expect(success.data![0].addressLine, tAddressModel.addressLine);
        verify(mockRemoteDataSource.getAllUserAddresses()).called(1);
      },
    );

    test(
      'should return SuccessResponse with empty list when data is null',
      () async {
        // Arrange
        when(mockRemoteDataSource.getAllUserAddresses()).thenAnswer(
          (_) async => SuccessResponse<List<AddressModel>>(null),
        );

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
      'should return ErrorResponse when remoteDataSource returns ErrorResponse',
      () async {
        // Arrange
        const errorMessage = 'Failed to fetch addresses';
        when(mockRemoteDataSource.getAllUserAddresses()).thenAnswer(
          (_) async => ErrorResponse<List<AddressModel>>(errorMessage),
        );

        // Act
        final result = await repository.getAllUserAddresses();

        // Assert
        expect(result, isA<ErrorResponse<List<AddressEntity>>>());
        final error = result as ErrorResponse<List<AddressEntity>>;
        expect(error.errorMessage, equals(errorMessage));
        verify(mockRemoteDataSource.getAllUserAddresses()).called(1);
      },
    );
  });

  group('setDefaultAddress', () {
    const tAddressId = 'address-1';
    final tDefaultResponse = DefaultAddressResponseModel(
      addressId: tAddressId,
      isDefault: true,
      updatedAt: DateTime(2026, 1, 1),
    );

    test(
      'should return SuccessResponse with mapped DefaultAddressEntity when remoteDataSource succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.setDefaultAddress(tAddressId)).thenAnswer(
          (_) async => SuccessResponse<DefaultAddressResponseModel>(tDefaultResponse),
        );

        // Act
        final result = await repository.setDefaultAddress(tAddressId);

        // Assert
        expect(result, isA<SuccessResponse<DefaultAddressEntity>>());
        final success = result as SuccessResponse<DefaultAddressEntity>;
        expect(success.data, isNotNull);
        expect(success.data!.addressId, equals(tAddressId));
        expect(success.data!.isDefault, isTrue);
        verify(mockRemoteDataSource.setDefaultAddress(tAddressId)).called(1);
      },
    );

    test(
      'should return ErrorResponse when remoteDataSource returns ErrorResponse',
      () async {
        // Arrange
        const errorMessage = 'Failed to set default address';
        when(mockRemoteDataSource.setDefaultAddress(tAddressId)).thenAnswer(
          (_) async => ErrorResponse<DefaultAddressResponseModel>(errorMessage),
        );

        // Act
        final result = await repository.setDefaultAddress(tAddressId);

        // Assert
        expect(result, isA<ErrorResponse<DefaultAddressEntity>>());
        final error = result as ErrorResponse<DefaultAddressEntity>;
        expect(error.errorMessage, equals(errorMessage));
        verify(mockRemoteDataSource.setDefaultAddress(tAddressId)).called(1);
      },
    );
  });

  group('deleteAddress', () {
    const tAddressId = 'address-1';
    const tSuccessMessage = 'Address deleted successfully';

    test(
      'should return SuccessResponse with message when remoteDataSource succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.deleteAddress(tAddressId)).thenAnswer(
          (_) async => SuccessResponse<String>(tSuccessMessage),
        );

        // Act
        final result = await repository.deleteAddress(tAddressId);

        // Assert
        expect(result, isA<SuccessResponse<String>>());
        final success = result as SuccessResponse<String>;
        expect(success.data, equals(tSuccessMessage));
        verify(mockRemoteDataSource.deleteAddress(tAddressId)).called(1);
      },
    );

    test(
      'should return ErrorResponse when remoteDataSource returns ErrorResponse',
      () async {
        // Arrange
        const errorMessage = 'Address not found';
        when(mockRemoteDataSource.deleteAddress(tAddressId)).thenAnswer(
          (_) async => ErrorResponse<String>(errorMessage),
        );

        // Act
        final result = await repository.deleteAddress(tAddressId);

        // Assert
        expect(result, isA<ErrorResponse<String>>());
        final error = result as ErrorResponse<String>;
        expect(error.errorMessage, equals(errorMessage));
        verify(mockRemoteDataSource.deleteAddress(tAddressId)).called(1);
      },
    );
  });
}

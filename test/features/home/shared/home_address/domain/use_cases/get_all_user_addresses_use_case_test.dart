import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/repositories/addresses_repository.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_user_addresses_use_case_test.mocks.dart';

@GenerateMocks([AddressesRepository])
void main() {
  provideDummy<BaseResponse<List<AddressEntity>>>(
    SuccessResponse<List<AddressEntity>>([]),
  );

  late MockAddressesRepository mockRepository;
  late GetAllUserAddressesUseCase useCase;

  setUp(() {
    mockRepository = MockAddressesRepository();

    useCase = GetAllUserAddressesUseCase(
      mockRepository,
    );
  });

  group('GetAllUserAddressesUseCase', () {
    test(
      'should call repository and return SuccessResponse with addresses',
      () async {
        // Arrange
        const address = AddressEntity(
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
        );

        final expectedResponse =
            SuccessResponse<List<AddressEntity>>(
          [address],
        );

        when(
          mockRepository.getAllUserAddresses(),
        ).thenAnswer(
          (_) async => expectedResponse,
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(expectedResponse));

        expect(
          result,
          isA<SuccessResponse<List<AddressEntity>>>(),
        );

        final success =
            result as SuccessResponse<List<AddressEntity>>;

        expect(success.data, isNotNull);
        expect(success.data!.length, 1);

        final resultAddress = success.data!.first;

        expect(resultAddress.id, 'address-1');
        expect(resultAddress.recipientName, 'Hesham');
        expect(resultAddress.recipientPhone, '01041149296');
        expect(resultAddress.addressLine, 'Helwan Main Street');
        expect(resultAddress.city, 'Helwan');
        expect(resultAddress.area, 'Helwan');
        expect(resultAddress.label, 'home');
        expect(resultAddress.lat, 29.8414);
        expect(resultAddress.lng, 31.3008);
        expect(resultAddress.isDefault, true);
        expect(resultAddress.storeId, isNull);
        expect(resultAddress.isServiceable, true);

        verify(
          mockRepository.getAllUserAddresses(),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponse when repository returns ErrorResponse',
      () async {
        // Arrange
        const errorMessage = 'Failed to get user addresses';

        final expectedResponse =
            ErrorResponse<List<AddressEntity>>(
          errorMessage,
        );

        when(
          mockRepository.getAllUserAddresses(),
        ).thenAnswer(
          (_) async => expectedResponse,
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(expectedResponse));

        expect(
          result,
          isA<ErrorResponse<List<AddressEntity>>>(),
        );

        final error =
            result as ErrorResponse<List<AddressEntity>>;

        expect(error.errorMessage, errorMessage);

        verify(
          mockRepository.getAllUserAddresses(),
        ).called(1);
      },
    );

    test(
      'should return empty list when repository returns empty list',
      () async {
        // Arrange
        final expectedResponse =
            SuccessResponse<List<AddressEntity>>([]);

        when(
          mockRepository.getAllUserAddresses(),
        ).thenAnswer(
          (_) async => expectedResponse,
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(expectedResponse));

        final success =
            result as SuccessResponse<List<AddressEntity>>;

        expect(success.data, isEmpty);

        verify(
          mockRepository.getAllUserAddresses(),
        ).called(1);
      },
    );
  });
}
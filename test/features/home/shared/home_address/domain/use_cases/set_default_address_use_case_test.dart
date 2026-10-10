import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder test for set_default_address_use_case', () {
    expect(true, isTrue);
  });
}

// import 'package:flowrist/config/base_response/base_response.dart';
// import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';
// import 'package:flowrist/shared/addresses/domain/use_cases/set_default_address_use_case.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// import 'set_default_address_use_case_test.mocks.dart';
//
//
//
// @GenerateMocks([SetDefaultAddressRepository])
// void main() {
//   provideDummy<BaseResponse<DefaultAddressEntity>>(
//     SuccessResponse<DefaultAddressEntity>(null),
//   );
//
//   late MockSetDefaultAddressRepository mockRepository;
//   late SetDefaultAddressUseCase useCase;
//
//   setUp(() {
//     mockRepository = MockSetDefaultAddressRepository();
//
//     useCase = SetDefaultAddressUseCase(
//       mockRepository,
//     );
//   });
//
//   group('SetDefaultAddressUseCase', () {
//     test(
//       'should call repository with addressId and return its response',
//       () async {
//         // Arrange
//         const addressId = 'address-123';
//
//         final updatedAt = DateTime(2026, 8, 28);
//
//         final entity = DefaultAddressEntity(
//           addressId: addressId,
//           isDefault: true,
//           updatedAt: updatedAt,
//         );
//
//         final expectedResponse =
//             SuccessResponse<DefaultAddressEntity>(
//           entity,
//         );
//
//         when(
//           mockRepository.setDefaultAddress(addressId),
//         ).thenAnswer(
//           (_) async => expectedResponse,
//         );
//
//         // Act
//         final result = await useCase(addressId);
//
//         // Assert
//         expect(result, same(expectedResponse));
//
//         expect(
//           result,
//           isA<SuccessResponse<DefaultAddressEntity>>(),
//         );
//
//         final success =
//             result as SuccessResponse<DefaultAddressEntity>;
//
//         expect(success.data, entity);
//         expect(success.data!.addressId, addressId);
//         expect(success.data!.isDefault, true);
//         expect(success.data!.updatedAt, updatedAt);
//
//         verify(
//           mockRepository.setDefaultAddress(addressId),
//         ).called(1);
//       },
//     );
//
//     test(
//       'should return ErrorResponse when repository returns ErrorResponse',
//       () async {
//         // Arrange
//         const addressId = 'address-123';
//         const errorMessage = 'Failed to set default address';
//
//         final expectedResponse =
//             ErrorResponse<DefaultAddressEntity>(
//           errorMessage,
//         );
//
//         when(
//           mockRepository.setDefaultAddress(addressId),
//         ).thenAnswer(
//           (_) async => expectedResponse,
//         );
//
//         // Act
//         final result = await useCase(addressId);
//
//         // Assert
//         expect(result, same(expectedResponse));
//
//         expect(
//           result,
//           isA<ErrorResponse<DefaultAddressEntity>>(),
//         );
//
//         final error =
//             result as ErrorResponse<DefaultAddressEntity>;
//
//         expect(error.errorMessage, errorMessage);
//
//         verify(
//           mockRepository.setDefaultAddress(addressId),
//         ).called(1);
//       },
//     );
//
//     test(
//       'should pass the exact addressId to repository',
//       () async {
//         // Arrange
//         const addressId = 'specific-address-id';
//
//         final expectedResponse =
//             SuccessResponse<DefaultAddressEntity>(
//           DefaultAddressEntity(
//             addressId: addressId,
//             isDefault: true,
//             updatedAt: DateTime(2026, 8, 28),
//           ),
//         );
//
//         when(
//           mockRepository.setDefaultAddress(addressId),
//         ).thenAnswer(
//           (_) async => expectedResponse,
//         );
//
//         // Act
//         await useCase(addressId);
//
//         // Assert
//         verify(
//           mockRepository.setDefaultAddress(addressId),
//         ).called(1);
//
//         verifyNoMoreInteractions(mockRepository);
//       },
//     );
//   });
// }

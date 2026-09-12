// import 'package:flowrist/config/base_response/base_response.dart';
// import 'package:flowrist/features/home/shared/home_address/data/data_sources/contract/remote/set_default_address_data_source.dart';
// import 'package:flowrist/shared/addresses/data/models/default_address_response_model.dart';
// import 'package:flowrist/features/home/shared/home_address/data/repositories/set_default_address_repository_impl.dart';
// import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// import 'set_default_address_repository_impl_test.mocks.dart';
//
// @GenerateMocks([SetDefaultAddressDataSource])
// void main() {
//   provideDummy<BaseResponse<DefaultAddressResponseModel>>(
//     SuccessResponse<DefaultAddressResponseModel>(null),
//   );
//
//   late MockSetDefaultAddressDataSource mockDataSource;
//   late SetDefaultAddressRepositoryImpl repository;
//
//   setUp(() {
//     mockDataSource = MockSetDefaultAddressDataSource();
//
//     repository = SetDefaultAddressRepositoryImpl(
//       mockDataSource,
//     );
//   });
//
//   group('setDefaultAddress', () {
//     test(
//       'should return SuccessResponse with mapped DefaultAddressEntity when datasource succeeds',
//       () async {
//         // Arrange
//         const addressId = 'address-123';
//
//         final updatedAt = DateTime(2026, 8, 28);
//
//         final model = DefaultAddressResponseModel(
//           addressId: addressId,
//           isDefault: true,
//           updatedAt: updatedAt,
//         );
//
//         when(
//           mockDataSource.setDefaultAddress(addressId),
//         ).thenAnswer(
//           (_) async => SuccessResponse<DefaultAddressResponseModel>(
//             model,
//           ),
//         );
//
//         // Act
//         final result = await repository.setDefaultAddress(
//           addressId,
//         );
//
//         // Assert
//         expect(
//           result,
//           isA<SuccessResponse<DefaultAddressEntity>>(),
//         );
//
//         final success =
//             result as SuccessResponse<DefaultAddressEntity>;
//
//         expect(success.data, isNotNull);
//
//         final entity = success.data!;
//
//         expect(entity.addressId, addressId);
//         expect(entity.addressId, model.addressId);
//
//         expect(entity.isDefault, true);
//         expect(entity.isDefault, model.isDefault);
//
//         expect(entity.updatedAt, updatedAt);
//         expect(entity.updatedAt, model.updatedAt);
//
//         verify(
//           mockDataSource.setDefaultAddress(addressId),
//         ).called(1);
//       },
//     );
//
//     test(
//       'should return SuccessResponse with null data when datasource returns null data',
//       () async {
//         // Arrange
//         const addressId = 'address-123';
//
//         when(
//           mockDataSource.setDefaultAddress(addressId),
//         ).thenAnswer(
//           (_) async => SuccessResponse<DefaultAddressResponseModel>(
//             null,
//           ),
//         );
//
//         // Act
//         final result = await repository.setDefaultAddress(
//           addressId,
//         );
//
//         // Assert
//         expect(
//           result,
//           isA<SuccessResponse<DefaultAddressEntity>>(),
//         );
//
//         final success =
//             result as SuccessResponse<DefaultAddressEntity>;
//
//         expect(success.data, isNull);
//
//         verify(
//           mockDataSource.setDefaultAddress(addressId),
//         ).called(1);
//       },
//     );
//
//     test(
//       'should return ErrorResponse when datasource returns ErrorResponse',
//       () async {
//         // Arrange
//         const addressId = 'address-123';
//         const errorMessage = 'Failed to set default address';
//
//         when(
//           mockDataSource.setDefaultAddress(addressId),
//         ).thenAnswer(
//           (_) async => ErrorResponse<DefaultAddressResponseModel>(
//             errorMessage,
//           ),
//         );
//
//         // Act
//         final result = await repository.setDefaultAddress(
//           addressId,
//         );
//
//         // Assert
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
//           mockDataSource.setDefaultAddress(addressId),
//         ).called(1);
//       },
//     );
//   });
// }

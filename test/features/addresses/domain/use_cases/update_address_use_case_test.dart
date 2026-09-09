import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/domain/repositories/add_address_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/update_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_address_use_case_test.mocks.dart';

@GenerateMocks([AddAddressRepository])
void main() {
  provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));

  late MockAddAddressRepository mockRepository;
  late UpdateAddressUseCase useCase;

  setUp(() {
    mockRepository = MockAddAddressRepository();
    useCase = UpdateAddressUseCase(mockRepository);
  });

  const tAddressId = 'addr_123';
  final tRequest = AddAddressRequestModel(
    recipientName: 'Ahmed',
    recipientPhone: '01010679792',
    addressLine: '123 Test St',
    governorateId: 2,
    cityId: 60,
    area: 'Cheikh Zayed',
    lat: 30.145406,
    lng: 31.3664664,
    label: 'home',
  );

  group('UpdateAddressUseCase Unit Tests', () {
    test(
      'should call repository.updateAddress and return SuccessResponse',
      () async {
        when(
          mockRepository.updateAddress(tAddressId, tRequest),
        ).thenAnswer((_) async => SuccessResponse<void>(null));

        final result = await useCase(tAddressId, tRequest);

        expect(result, isA<SuccessResponse<void>>());
        verify(mockRepository.updateAddress(tAddressId, tRequest)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should call repository.updateAddress and return ErrorResponse', () async {
      when(mockRepository.updateAddress(tAddressId, tRequest)).thenAnswer(
        (_) async => ErrorResponse<void>(
          'Cannot update address: The new location is outside our delivery coverage.',
        ),
      );

      final result = await useCase(tAddressId, tRequest);

      expect(result, isA<ErrorResponse<void>>());
      expect(
        (result as ErrorResponse).errorMessage,
        equals(
          'Cannot update address: The new location is outside our delivery coverage.',
        ),
      );
      verify(mockRepository.updateAddress(tAddressId, tRequest)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

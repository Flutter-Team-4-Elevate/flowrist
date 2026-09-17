import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/domain/repositories/addresses_repository.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/delete_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_address_use_case_test.mocks.dart';

@GenerateMocks([AddressesRepository])
void main() {
  provideDummy<BaseResponse<String>>(
    SuccessResponse<String>('Address deleted successfully.'),
  );

  late MockAddressesRepository mockRepository;
  late DeleteAddressUseCase useCase;

  setUp(() {
    mockRepository = MockAddressesRepository();
    useCase = DeleteAddressUseCase(mockRepository);
  });

  const tAddressId = 'addr_123';

  group('DeleteAddressUseCase Unit Tests', () {
    test(
      'should call repository.deleteAddress and return SuccessResponse',
      () async {
        when(mockRepository.deleteAddress(tAddressId)).thenAnswer(
          (_) async => SuccessResponse<String>('Address deleted successfully.'),
        );

        final result = await useCase(tAddressId);

        expect(result, isA<SuccessResponse<String>>());
        expect(
          (result as SuccessResponse).data,
          equals('Address deleted successfully.'),
        );
        verify(mockRepository.deleteAddress(tAddressId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should call repository.deleteAddress and return ErrorResponse',
      () async {
        when(
          mockRepository.deleteAddress(tAddressId),
        ).thenAnswer((_) async => ErrorResponse<String>('Address not found.'));

        final result = await useCase(tAddressId);

        expect(result, isA<ErrorResponse<String>>());
        expect(
          (result as ErrorResponse).errorMessage,
          equals('Address not found.'),
        );
        verify(mockRepository.deleteAddress(tAddressId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}

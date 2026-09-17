import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepository;
  late LogoutUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<void>>(SuccessResponse(null));
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should delegate call to ProfileRepository.logout', () async {
      when(
        mockRepository.logout(),
      ).thenAnswer((_) async => SuccessResponse(null));

      final result = await useCase();

      expect(result, isA<SuccessResponse<void>>());
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/change_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepository;
  late ChangePasswordUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<void>>(SuccessResponse(null));
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = ChangePasswordUseCase(mockRepository);
  });

  group('ChangePasswordUseCase', () {
    const request = ChangePasswordRequestDto(
      currentPassword: 'OldPassword123!',
      newPassword: 'NewPassword123!',
      confirmNewPassword: 'NewPassword123!',
    );

    test('should delegate call to ProfileRepository.changePassword', () async {
      when(
        mockRepository.changePassword(request),
      ).thenAnswer((_) async => SuccessResponse(null));

      final result = await useCase(request);

      expect(result, isA<SuccessResponse<void>>());
      verify(mockRepository.changePassword(request)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

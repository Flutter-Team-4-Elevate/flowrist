import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/domain/repositories/sessions_repository.dart';
import 'package:flowrist/features/home/profile/session_management/domain/use_cases/revoke_session_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SessionsRepository])
import 'revoke_session_use_case_test.mocks.dart';

void main() {
  late MockSessionsRepository mockRepository;
  late RevokeSessionUseCase useCase;

  setUp(() {
    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
    mockRepository = MockSessionsRepository();
    useCase = RevokeSessionUseCase(mockRepository);
  });

  const tSessionId = 'sess_1';

  test('should call repository.revokeSession with target sessionId', () async {
    when(
      mockRepository.revokeSession(tSessionId),
    ).thenAnswer((_) async => SuccessResponse<void>(null));

    final result = await useCase(tSessionId);

    expect(result, isA<SuccessResponse<void>>());
    verify(mockRepository.revokeSession(tSessionId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

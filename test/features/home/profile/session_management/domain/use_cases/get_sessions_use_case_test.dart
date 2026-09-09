import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flowrist/features/home/profile/session_management/domain/repositories/sessions_repository.dart';
import 'package:flowrist/features/home/profile/session_management/domain/use_cases/get_sessions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SessionsRepository])
import 'get_sessions_use_case_test.mocks.dart';

void main() {
  late MockSessionsRepository mockRepository;
  late GetSessionsUseCase useCase;

  setUp(() {
    provideDummy<BaseResponse<List<SessionEntity>>>(
      SuccessResponse<List<SessionEntity>>([]),
    );
    mockRepository = MockSessionsRepository();
    useCase = GetSessionsUseCase(mockRepository);
  });

  const tSessionList = [
    SessionEntity(
      id: 'sess_1',
      deviceName: 'iPhone 15',
      ipAddress: '192.168.1.1',
      location: 'Cairo',
      createdAt: '2026-09-01',
      lastUsedAt: '2026-09-04',
      isCurrent: true,
    ),
  ];

  test('should return list of sessions from repository when called', () async {
    when(mockRepository.getSessions()).thenAnswer(
      (_) async => SuccessResponse<List<SessionEntity>>(tSessionList),
    );

    final result = await useCase();

    expect(result, isA<SuccessResponse<List<SessionEntity>>>());
    expect(
      (result as SuccessResponse<List<SessionEntity>>).data,
      equals(tSessionList),
    );
    verify(mockRepository.getSessions()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

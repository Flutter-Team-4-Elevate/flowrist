import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flowrist/features/home/profile/session_management/domain/use_cases/get_sessions_use_case.dart';
import 'package:flowrist/features/home/profile/session_management/domain/use_cases/revoke_session_use_case.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_cubit.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_events.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetSessionsUseCase, RevokeSessionUseCase])
import 'sessions_cubit_test.mocks.dart';

void main() {
  late MockGetSessionsUseCase mockGetSessionsUseCase;
  late MockRevokeSessionUseCase mockRevokeSessionUseCase;
  late SessionsCubit cubit;

  const tSession1 = SessionEntity(
    id: 'sess_1',
    deviceName: 'Current Device',
    ipAddress: '192.168.1.1',
    location: 'Cairo',
    createdAt: '2026-09-01',
    lastUsedAt: '2026-09-04',
    isCurrent: true,
  );

  const tSession2 = SessionEntity(
    id: 'sess_2',
    deviceName: 'Other Phone',
    ipAddress: '192.168.1.5',
    location: 'Giza',
    createdAt: '2026-08-15',
    lastUsedAt: '2026-09-02',
    isCurrent: false,
  );

  setUp(() {
    provideDummy<BaseResponse<List<SessionEntity>>>(
      SuccessResponse<List<SessionEntity>>([]),
    );
    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));

    mockGetSessionsUseCase = MockGetSessionsUseCase();
    mockRevokeSessionUseCase = MockRevokeSessionUseCase();
    cubit = SessionsCubit(mockGetSessionsUseCase, mockRevokeSessionUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be SessionsState.initial()', () {
    expect(cubit.state, equals(SessionsState.initial()));
  });

  group('GetSessionsEvent', () {
    blocTest<SessionsCubit, SessionsState>(
      'emits [loading, success] when getSessions succeeds',
      build: () {
        when(mockGetSessionsUseCase()).thenAnswer(
          (_) async =>
              SuccessResponse<List<SessionEntity>>([tSession1, tSession2]),
        );
        return cubit;
      },
      act: (c) => c.doEvent(const GetSessionsEvent()),
      expect: () => [
        SessionsState.initial().copyWith(
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
          clearSuccessMessage: true,
        ),
        SessionsState.initial().copyWith(
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: false,
            errorMessage: null,
            data: [tSession1, tSession2],
          ),
          clearSuccessMessage: true,
        ),
      ],
      verify: (_) {
        verify(mockGetSessionsUseCase()).called(1);
      },
    );

    blocTest<SessionsCubit, SessionsState>(
      'emits [loading, error] when getSessions fails',
      build: () {
        when(mockGetSessionsUseCase()).thenAnswer(
          (_) async => ErrorResponse<List<SessionEntity>>('Server unreachable'),
        );
        return cubit;
      },
      act: (c) => c.doEvent(const GetSessionsEvent()),
      expect: () => [
        SessionsState.initial().copyWith(
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
          clearSuccessMessage: true,
        ),
        SessionsState.initial().copyWith(
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: false,
            errorMessage: 'Server unreachable',
            data: null,
          ),
          clearSuccessMessage: true,
        ),
      ],
      verify: (_) {
        verify(mockGetSessionsUseCase()).called(1);
      },
    );
  });

  group('RevokeSessionEvent', () {
    const tRevokeId = 'sess_2';

    blocTest<SessionsCubit, SessionsState>(
      'removes revoked session from list and emits successMessage on success',
      seed: () => SessionsState.initial().copyWith(
        sessions: const BaseState<List<SessionEntity>>(
          isLoading: false,
          errorMessage: null,
          data: [tSession1, tSession2],
        ),
      ),
      build: () {
        when(
          mockRevokeSessionUseCase(tRevokeId),
        ).thenAnswer((_) async => SuccessResponse<void>(null));
        return cubit;
      },
      act: (c) => c.doEvent(const RevokeSessionEvent(tRevokeId)),
      expect: () => [
        SessionsState.initial().copyWith(
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: false,
            errorMessage: null,
            data: [tSession1, tSession2],
          ),
          revokingSessionId: tRevokeId,
          clearSuccessMessage: true,
        ),
        SessionsState.initial().copyWith(
          clearRevokingId: true,
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: false,
            errorMessage: null,
            data: [tSession1],
          ),
          successMessage: AppConstants.sessionRevokedSuccessfully,
        ),
      ],
      verify: (_) {
        verify(mockRevokeSessionUseCase(tRevokeId)).called(1);
      },
    );

    blocTest<SessionsCubit, SessionsState>(
      'clears revokingId and emits errorMessage on failure',
      seed: () => SessionsState.initial().copyWith(
        sessions: const BaseState<List<SessionEntity>>(
          isLoading: false,
          errorMessage: null,
          data: [tSession1, tSession2],
        ),
      ),
      build: () {
        when(mockRevokeSessionUseCase(tRevokeId)).thenAnswer(
          (_) async => ErrorResponse<void>('Could not revoke session'),
        );
        return cubit;
      },
      act: (c) => c.doEvent(const RevokeSessionEvent(tRevokeId)),
      expect: () => [
        SessionsState.initial().copyWith(
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: false,
            errorMessage: null,
            data: [tSession1, tSession2],
          ),
          revokingSessionId: tRevokeId,
          clearSuccessMessage: true,
        ),
        SessionsState.initial().copyWith(
          clearRevokingId: true,
          sessions: const BaseState<List<SessionEntity>>(
            isLoading: false,
            errorMessage: 'Could not revoke session',
            data: [tSession1, tSession2],
          ),
        ),
      ],
      verify: (_) {
        verify(mockRevokeSessionUseCase(tRevokeId)).called(1);
      },
    );
  });
}

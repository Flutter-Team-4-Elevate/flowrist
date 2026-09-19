import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/data/data_sources/contract/sessions_remote_data_source.dart';
import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';
import 'package:flowrist/features/home/profile/session_management/data/repositories/sessions_repository_impl.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SessionsRemoteDataSource])
import 'sessions_repository_impl_test.mocks.dart';

void main() {
  late MockSessionsRemoteDataSource mockRemoteDataSource;
  late SessionsRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockSessionsRemoteDataSource();
    repository = SessionsRepositoryImpl(mockRemoteDataSource);
  });

  group('getSessions', () {
    const tResponseDto = SessionsResponseDto(
      status: true,
      code: 200,
      data: [
        SessionItemDto(
          id: 'sess_1',
          deviceName: 'Chrome Windows',
          ipAddress: '10.0.0.1',
          location: 'Alexandria',
          createdAt: '2026-08-01',
          lastUsedAt: '2026-09-04',
          isCurrent: true,
        ),
      ],
    );

    test(
      'should return SuccessResponse<List<SessionEntity>> on success',
      () async {
        when(
          mockRemoteDataSource.getSessions(),
        ).thenAnswer((_) async => tResponseDto);

        final result = await repository.getSessions();

        expect(result, isA<SuccessResponse<List<SessionEntity>>>());
        final entities = (result as SuccessResponse<List<SessionEntity>>).data;
        expect(entities?.first.id, equals('sess_1'));
        expect(entities?.first.deviceName, equals('Chrome Windows'));
        verify(mockRemoteDataSource.getSessions()).called(1);
      },
    );

    test(
      'should return Failure/ErrorResponse when remote data source throws exception',
      () async {
        when(
          mockRemoteDataSource.getSessions(),
        ).thenThrow(Exception('SocketException'));

        final result = await repository.getSessions();

        expect(result, isNot(isA<SuccessResponse<List<SessionEntity>>>()));
        verify(mockRemoteDataSource.getSessions()).called(1);
      },
    );
  });

  group('revokeSession', () {
    const tSessionId = 'sess_1';

    test('should return SuccessResponse<void> on success', () async {
      when(
        mockRemoteDataSource.revokeSession(tSessionId),
      ).thenAnswer((_) async => const RevokeSessionResponseDto(status: true));

      final result = await repository.revokeSession(tSessionId);

      expect(result, isA<SuccessResponse<void>>());
      verify(mockRemoteDataSource.revokeSession(tSessionId)).called(1);
    });

    test(
      'should return Failure/ErrorResponse when remote data source throws exception',
      () async {
        when(
          mockRemoteDataSource.revokeSession(tSessionId),
        ).thenThrow(Exception('Server error'));

        final result = await repository.revokeSession(tSessionId);

        expect(result, isNot(isA<SuccessResponse<void>>()));
        verify(mockRemoteDataSource.revokeSession(tSessionId)).called(1);
      },
    );
  });
}

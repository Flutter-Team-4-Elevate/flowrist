import 'package:flowrist/features/home/profile/session_management/data/client/sessions_api_client.dart';
import 'package:flowrist/features/home/profile/session_management/data/data_sources/impl/sessions_remote_data_source_impl.dart';
import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SessionsApiClient])
import 'sessions_remote_data_source_impl_test.mocks.dart';

void main() {
  late MockSessionsApiClient mockApiClient;
  late SessionsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockSessionsApiClient();
    dataSource = SessionsRemoteDataSourceImpl(mockApiClient);
  });

  group('SessionsRemoteDataSourceImpl - getSessions', () {
    const tResponseDto = SessionsResponseDto(
      status: true,
      code: 200,
      message: 'Success',
      data: [
        SessionItemDto(
          id: 'sess_1',
          deviceName: 'Pixel 8',
          ipAddress: '192.168.1.1',
          location: 'Cairo, Egypt',
          createdAt: '2026-09-01',
          lastUsedAt: '2026-09-04',
          isCurrent: true,
        ),
      ],
    );

    test(
      'should call apiClient.getSessions and return SessionsResponseDto',
      () async {
        when(mockApiClient.getSessions()).thenAnswer((_) async => tResponseDto);

        final result = await dataSource.getSessions();

        expect(result, equals(tResponseDto));
        verify(mockApiClient.getSessions()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow exception when apiClient.getSessions throws',
      () async {
        when(mockApiClient.getSessions()).thenThrow(Exception('Server error'));

        expect(() => dataSource.getSessions(), throwsA(isA<Exception>()));
        verify(mockApiClient.getSessions()).called(1);
      },
    );
  });

  group('SessionsRemoteDataSourceImpl - revokeSession', () {
    const tSessionId = 'sess_1';
    const tRevokeDto = RevokeSessionResponseDto(
      status: true,
      code: 200,
      message: 'Session revoked successfully',
    );

    test(
      'should call apiClient.revokeSession with sessionId and return RevokeSessionResponseDto',
      () async {
        when(
          mockApiClient.revokeSession(tSessionId),
        ).thenAnswer((_) async => tRevokeDto);

        final result = await dataSource.revokeSession(tSessionId);

        expect(result, equals(tRevokeDto));
        verify(mockApiClient.revokeSession(tSessionId)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow exception when apiClient.revokeSession throws',
      () async {
        when(
          mockApiClient.revokeSession(tSessionId),
        ).thenThrow(Exception('Unauthorized'));

        expect(
          () => dataSource.revokeSession(tSessionId),
          throwsA(isA<Exception>()),
        );
        verify(mockApiClient.revokeSession(tSessionId)).called(1);
      },
    );
  });
}

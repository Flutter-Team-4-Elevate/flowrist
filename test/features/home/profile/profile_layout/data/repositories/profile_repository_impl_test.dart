import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/repositories/profile_repository_impl.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource, SessionService])
void main() {
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockSessionService mockSessionService;
  late ProfileRepository repository;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockSessionService = MockSessionService();
    repository = ProfileRepositoryImpl(
      mockRemoteDataSource,
      mockSessionService,
    );
  });

  group('ProfileRepositoryImpl.logout', () {
    const refreshToken = 'sample_refresh_token';

    test(
      'should clear session and return SuccessResponse when remote logout succeeds',
      () async {
        when(
          mockSessionService.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);
        when(
          mockRemoteDataSource.logout(any),
        ).thenAnswer((_) async => const LogoutResponseDto(status: true));
        when(mockSessionService.clearSession()).thenAnswer((_) async => {});

        final result = await repository.logout();

        expect(result, isA<SuccessResponse<void>>());
        verify(mockSessionService.getRefreshToken()).called(1);
        verify(mockRemoteDataSource.logout(any)).called(1);
        verify(mockSessionService.clearSession()).called(1);
      },
    );

    test(
      'should clear session and return ErrorResponse when remote logout fails',
      () async {
        when(
          mockSessionService.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);
        when(
          mockRemoteDataSource.logout(any),
        ).thenThrow(Exception('Network issue'));
        when(mockSessionService.clearSession()).thenAnswer((_) async => {});

        final result = await repository.logout();

        expect(result, isA<ErrorResponse<void>>());
        verify(mockSessionService.clearSession()).called(1);
      },
    );
  });
}

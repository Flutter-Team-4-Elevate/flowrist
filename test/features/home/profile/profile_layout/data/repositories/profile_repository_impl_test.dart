import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/change_password_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/user_profile_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/repositories/profile_repository_impl.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
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

  group('ProfileRepositoryImpl.getProfile', () {
    const userDto = UserProfileDto(
      id: '1',
      firstName: 'Ali',
      lastName: 'Ibrahim',
      email: 'ali@example.com',
      phoneNumber: '01000000000',
      gender: 0,
      profilePictureUrl: 'https://example.com/pic.jpg',
    );

    test(
      'should return SuccessResponse<UserProfileEntity> when getProfile succeeds with status true and data not null',
      () async {
        when(mockRemoteDataSource.getProfile()).thenAnswer(
          (_) async =>
              const UserProfileResponseDto(status: true, data: userDto),
        );

        final result = await repository.getProfile();

        expect(result, isA<SuccessResponse<UserProfileEntity>>());
        final data = (result as SuccessResponse<UserProfileEntity>).data;
        expect(data?.id, '1');
        expect(data?.firstName, 'Ali');
        verify(mockRemoteDataSource.getProfile()).called(1);
      },
    );

    test(
      'should return ErrorResponse when getProfile status is false',
      () async {
        when(mockRemoteDataSource.getProfile()).thenAnswer(
          (_) async => const UserProfileResponseDto(
            status: false,
            message: 'User not found',
          ),
        );

        final result = await repository.getProfile();

        expect(result, isA<ErrorResponse<UserProfileEntity>>());
        expect(
          (result as ErrorResponse<UserProfileEntity>).errorMessage,
          'User not found',
        );
        verify(mockRemoteDataSource.getProfile()).called(1);
      },
    );

    test(
      'should return ErrorResponse through ApiErrorHandler when getProfile throws Exception',
      () async {
        when(
          mockRemoteDataSource.getProfile(),
        ).thenThrow(Exception('Network error'));

        final result = await repository.getProfile();

        expect(result, isA<ErrorResponse<UserProfileEntity>>());
        verify(mockRemoteDataSource.getProfile()).called(1);
      },
    );
  });

  group('ProfileRepositoryImpl.updateProfile', () {
    const request = UpdateProfileRequestDto(
      firstName: 'Ali',
      lastName: 'Ibrahim',
      phoneNumber: '01000000000',
      gender: 0,
      profilePictureUrl: 'https://example.com/new_pic.jpg',
    );
    const updatedDto = UserProfileDto(
      id: '1',
      firstName: 'Ali',
      lastName: 'Ibrahim',
      email: 'ali@example.com',
      phoneNumber: '01000000000',
      gender: 0,
      profilePictureUrl: 'https://example.com/new_pic.jpg',
    );

    test(
      'should return SuccessResponse<UserProfileEntity> when updateProfile succeeds',
      () async {
        when(mockRemoteDataSource.updateProfile(request)).thenAnswer(
          (_) async =>
              const UserProfileResponseDto(status: true, data: updatedDto),
        );

        final result = await repository.updateProfile(request);

        expect(result, isA<SuccessResponse<UserProfileEntity>>());
        final data = (result as SuccessResponse<UserProfileEntity>).data;
        expect(data?.profilePictureUrl, 'https://example.com/new_pic.jpg');
        verify(mockRemoteDataSource.updateProfile(request)).called(1);
      },
    );

    test(
      'should return ErrorResponse when updateProfile returns status false',
      () async {
        when(mockRemoteDataSource.updateProfile(request)).thenAnswer(
          (_) async => const UserProfileResponseDto(
            status: false,
            message: 'Update failed',
          ),
        );

        final result = await repository.updateProfile(request);

        expect(result, isA<ErrorResponse<UserProfileEntity>>());
        expect(
          (result as ErrorResponse<UserProfileEntity>).errorMessage,
          'Update failed',
        );
        verify(mockRemoteDataSource.updateProfile(request)).called(1);
      },
    );

    test(
      'should return ErrorResponse through ApiErrorHandler when updateProfile throws Exception',
      () async {
        when(
          mockRemoteDataSource.updateProfile(request),
        ).thenThrow(Exception('Server error'));

        final result = await repository.updateProfile(request);

        expect(result, isA<ErrorResponse<UserProfileEntity>>());
        verify(mockRemoteDataSource.updateProfile(request)).called(1);
      },
    );
  });

  group('ProfileRepositoryImpl.changePassword', () {
    const request = ChangePasswordRequestDto(
      currentPassword: 'OldPassword123!',
      newPassword: 'NewPassword123!',
      confirmNewPassword: 'NewPassword123!',
    );

    test(
      'should clear session and return SuccessResponse when changePassword succeeds with status true',
      () async {
        when(mockRemoteDataSource.changePassword(request)).thenAnswer(
          (_) async => const ChangePasswordResponseDto(status: true),
        );
        when(mockSessionService.clearSession()).thenAnswer((_) async => {});

        final result = await repository.changePassword(request);

        expect(result, isA<SuccessResponse<void>>());
        verify(mockRemoteDataSource.changePassword(request)).called(1);
        verify(mockSessionService.clearSession()).called(1);
      },
    );

    test(
      'should return ErrorResponse when changePassword returns status false',
      () async {
        when(mockRemoteDataSource.changePassword(request)).thenAnswer(
          (_) async => const ChangePasswordResponseDto(
            status: false,
            message: 'Current password invalid',
          ),
        );

        final result = await repository.changePassword(request);

        expect(result, isA<ErrorResponse<void>>());
        expect(
          (result as ErrorResponse).errorMessage,
          'Current password invalid',
        );
        verify(mockRemoteDataSource.changePassword(request)).called(1);
        verifyNever(mockSessionService.clearSession());
      },
    );

    test(
      'should return ErrorResponse through ApiErrorHandler when changePassword throws Exception',
      () async {
        when(
          mockRemoteDataSource.changePassword(request),
        ).thenThrow(Exception('Server unreachable'));

        final result = await repository.changePassword(request);

        expect(result, isA<ErrorResponse<void>>());
        verify(mockRemoteDataSource.changePassword(request)).called(1);
        verifyNever(mockSessionService.clearSession());
      },
    );
  });
}

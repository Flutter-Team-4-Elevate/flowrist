import 'package:flowrist/features/home/profile/profile_layout/data/client/profile_api_client.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/impl/profile_remote_data_source_impl.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/change_password_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/user_profile_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient mockApiClient;
  late ProfileRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient);
  });

  group('ProfileRemoteDataSourceImpl.logout', () {
    const request = LogoutRequestDto(refreshToken: 'test_token');
    const response = LogoutResponseDto(
      status: true,
      code: 200,
      message: 'Logged out',
    );

    test(
      'should return LogoutResponseDto when api client completes successfully',
      () async {
        when(mockApiClient.logout(request)).thenAnswer((_) async => response);

        final result = await dataSource.logout(request);

        expect(result, response);
        verify(mockApiClient.logout(request)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should rethrow Exception when api client throws an error', () async {
      when(mockApiClient.logout(request)).thenThrow(Exception('Server error'));

      expect(() => dataSource.logout(request), throwsA(isA<Exception>()));
      verify(mockApiClient.logout(request)).called(1);
    });
  });

  group('ProfileRemoteDataSourceImpl.getProfile', () {
    const response = UserProfileResponseDto(
      status: true,
      code: 200,
      message: 'Success',
      data: UserProfileDto(
        id: '1',
        firstName: 'Ali',
        lastName: 'Ibrahim',
        email: 'ali@example.com',
        phoneNumber: '01000000000',
        gender: 0,
        profilePictureUrl: 'https://example.com/pic.jpg',
      ),
    );

    test(
      'should return UserProfileResponseDto when api client completes successfully',
      () async {
        when(mockApiClient.getProfile()).thenAnswer((_) async => response);

        final result = await dataSource.getProfile();

        expect(result, response);
        verify(mockApiClient.getProfile()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should rethrow Exception when api client throws an error', () async {
      when(mockApiClient.getProfile()).thenThrow(Exception('Server error'));

      expect(() => dataSource.getProfile(), throwsA(isA<Exception>()));
      verify(mockApiClient.getProfile()).called(1);
    });
  });

  group('ProfileRemoteDataSourceImpl.updateProfile', () {
    const request = UpdateProfileRequestDto(
      firstName: 'Ali',
      lastName: 'Ibrahim',
      phoneNumber: '01000000000',
      gender: 0,
      profilePictureUrl: 'https://example.com/new_pic.jpg',
    );
    const response = UserProfileResponseDto(
      status: true,
      code: 200,
      message: 'Profile updated',
      data: UserProfileDto(
        id: '1',
        firstName: 'Ali',
        lastName: 'Ibrahim',
        email: 'ali@example.com',
        phoneNumber: '01000000000',
        gender: 0,
        profilePictureUrl: 'https://example.com/new_pic.jpg',
      ),
    );

    test(
      'should return UserProfileResponseDto when updateProfile completes successfully',
      () async {
        when(
          mockApiClient.updateProfile(request),
        ).thenAnswer((_) async => response);

        final result = await dataSource.updateProfile(request);

        expect(result, response);
        verify(mockApiClient.updateProfile(request)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow Exception when updateProfile throws an error',
      () async {
        when(
          mockApiClient.updateProfile(request),
        ).thenThrow(Exception('Network error'));

        expect(
          () => dataSource.updateProfile(request),
          throwsA(isA<Exception>()),
        );
        verify(mockApiClient.updateProfile(request)).called(1);
      },
    );
  });

  group('ProfileRemoteDataSourceImpl.changePassword', () {
    const request = ChangePasswordRequestDto(
      currentPassword: 'OldPassword123!',
      newPassword: 'NewPassword123!',
      confirmNewPassword: 'NewPassword123!',
    );
    const response = ChangePasswordResponseDto(
      status: true,
      code: 200,
      message: 'Password changed successfully',
    );

    test(
      'should return ChangePasswordResponseDto when changePassword completes successfully',
      () async {
        when(
          mockApiClient.changePassword(request),
        ).thenAnswer((_) async => response);

        final result = await dataSource.changePassword(request);

        expect(result, response);
        verify(mockApiClient.changePassword(request)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow Exception when changePassword throws an error',
      () async {
        when(
          mockApiClient.changePassword(request),
        ).thenThrow(Exception('Server error'));

        expect(
          () => dataSource.changePassword(request),
          throwsA(isA<Exception>()),
        );
        verify(mockApiClient.changePassword(request)).called(1);
      },
    );
  });
}

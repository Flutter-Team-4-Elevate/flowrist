import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/change_password_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/get_profile_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/logout_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/update_profile_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_cubit.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([
  LogoutUseCase,
  GetProfileUseCase,
  UpdateProfileUseCase,
  ChangePasswordUseCase,
])
void main() {
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  const mockUser = UserProfileEntity(
    id: '1',
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phoneNumber: '01000000000',
    gender: 0,
    profilePictureUrl: 'https://example.com/pic.jpg',
  );

  setUpAll(() {
    provideDummy<BaseResponse<void>>(SuccessResponse(null));
    provideDummy<BaseResponse<UserProfileEntity>>(SuccessResponse(mockUser));
  });

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();
  });

  ProfileCubit createCubit() {
    return ProfileCubit(
      mockLogoutUseCase,
      mockGetProfileUseCase,
      mockUpdateProfileUseCase,
      mockChangePasswordUseCase,
    );
  }

  group('ProfileCubit', () {
    test('initial state has BaseState.initial() for all states', () {
      final cubit = createCubit();
      expect(cubit.state, const ProfileState());
      cubit.close();
    });

    // ==================================================
    // LOGOUT
    // ==================================================
    group('LogoutEvent', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, success] when LogoutEvent succeeds',
        build: () {
          when(
            mockLogoutUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse(null));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const LogoutEvent()),
        expect: () => [
          ProfileState(logoutState: BaseState.loading()),
          const ProfileState(
            logoutState: BaseState(
              isLoading: false,
              errorMessage: null,
              data: null,
            ),
          ),
        ],
        verify: (_) {
          verify(mockLogoutUseCase.call()).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, error] when LogoutEvent fails',
        build: () {
          when(
            mockLogoutUseCase.call(),
          ).thenAnswer((_) async => ErrorResponse('Session expired'));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const LogoutEvent()),
        expect: () => [
          ProfileState(logoutState: BaseState.loading()),
          ProfileState(logoutState: BaseState.error('Session expired')),
        ],
        verify: (_) {
          verify(mockLogoutUseCase.call()).called(1);
        },
      );
    });

    // ==================================================
    // GET PROFILE
    // ==================================================
    group('GetProfileEvent', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, success] when GetProfileEvent returns user data',
        build: () {
          when(
            mockGetProfileUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse(mockUser));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const GetProfileEvent()),
        expect: () => [
          ProfileState(profileState: BaseState.loading()),
          ProfileState(profileState: BaseState.success(mockUser)),
        ],
        verify: (_) {
          verify(mockGetProfileUseCase.call()).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, error] when GetProfileEvent returns null data',
        build: () {
          when(
            mockGetProfileUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse<UserProfileEntity>(null));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const GetProfileEvent()),
        expect: () => [
          ProfileState(profileState: BaseState.loading()),
          ProfileState(profileState: BaseState.error('No profile data found')),
        ],
        verify: (_) {
          verify(mockGetProfileUseCase.call()).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, error] when GetProfileEvent returns ErrorResponse',
        build: () {
          when(
            mockGetProfileUseCase.call(),
          ).thenAnswer((_) async => ErrorResponse('User not found'));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const GetProfileEvent()),
        expect: () => [
          ProfileState(profileState: BaseState.loading()),
          ProfileState(profileState: BaseState.error('User not found')),
        ],
        verify: (_) {
          verify(mockGetProfileUseCase.call()).called(1);
        },
      );
    });

    // ==================================================
    // UPDATE PROFILE
    // ==================================================
    group('UpdateProfileEvent', () {
      const request = UpdateProfileRequestDto(
        firstName: 'Ali',
        lastName: 'Ibrahim',
        phoneNumber: '01000000000',
        gender: 0,
        profilePictureUrl: 'https://example.com/pic.jpg',
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, success (both update & profile states)] when UpdateProfileEvent succeeds',
        build: () {
          when(
            mockUpdateProfileUseCase.call(request),
          ).thenAnswer((_) async => SuccessResponse(mockUser));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const UpdateProfileEvent(request)),
        expect: () => [
          ProfileState(updateProfileState: BaseState.loading()),
          ProfileState(
            updateProfileState: BaseState.success(mockUser),
            profileState: BaseState.success(mockUser),
          ),
        ],
        verify: (_) {
          verify(mockUpdateProfileUseCase.call(request)).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, error] when UpdateProfileEvent returns null data',
        build: () {
          when(
            mockUpdateProfileUseCase.call(request),
          ).thenAnswer((_) async => SuccessResponse<UserProfileEntity>(null));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const UpdateProfileEvent(request)),
        expect: () => [
          ProfileState(updateProfileState: BaseState.loading()),
          ProfileState(
            updateProfileState: BaseState.error(
              'Failed to update profile data',
            ),
          ),
        ],
        verify: (_) {
          verify(mockUpdateProfileUseCase.call(request)).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, error] when UpdateProfileEvent returns ErrorResponse',
        build: () {
          when(
            mockUpdateProfileUseCase.call(request),
          ).thenAnswer((_) async => ErrorResponse('Validation failed'));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const UpdateProfileEvent(request)),
        expect: () => [
          ProfileState(updateProfileState: BaseState.loading()),
          ProfileState(
            updateProfileState: BaseState.error('Validation failed'),
          ),
        ],
        verify: (_) {
          verify(mockUpdateProfileUseCase.call(request)).called(1);
        },
      );
    });

    // ==================================================
    // CHANGE PASSWORD
    // ==================================================
    group('ChangePasswordEvent', () {
      const request = ChangePasswordRequestDto(
        currentPassword: 'OldPassword123!',
        newPassword: 'NewPassword123!',
        confirmNewPassword: 'NewPassword123!',
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, success] when ChangePasswordEvent succeeds',
        build: () {
          when(
            mockChangePasswordUseCase.call(request),
          ).thenAnswer((_) async => SuccessResponse(null));
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const ChangePasswordEvent(request)),
        expect: () => [
          ProfileState(changePasswordState: BaseState.loading()),
          const ProfileState(
            changePasswordState: BaseState(
              isLoading: false,
              errorMessage: null,
              data: null,
            ),
          ),
        ],
        verify: (_) {
          verify(mockChangePasswordUseCase.call(request)).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, error] when ChangePasswordEvent fails',
        build: () {
          when(mockChangePasswordUseCase.call(request)).thenAnswer(
            (_) async => ErrorResponse('Current password does not match'),
          );
          return createCubit();
        },
        act: (cubit) => cubit.doEvent(const ChangePasswordEvent(request)),
        expect: () => [
          ProfileState(changePasswordState: BaseState.loading()),
          ProfileState(
            changePasswordState: BaseState.error(
              'Current password does not match',
            ),
          ),
        ],
        verify: (_) {
          verify(mockChangePasswordUseCase.call(request)).called(1);
        },
      );
    });
  });
}

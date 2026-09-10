import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/logout_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_cubit.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([LogoutUseCase])
void main() {
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    provideDummy<BaseResponse<void>>(SuccessResponse(null));
    mockLogoutUseCase = MockLogoutUseCase();
  });

  group('ProfileCubit', () {
    test('initial state has BaseState.initial() for logoutState', () {
      final cubit = ProfileCubit(mockLogoutUseCase);
      expect(cubit.state, const ProfileState());
      cubit.close();
    });

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when LogoutEvent succeeds',
      build: () {
        when(
          mockLogoutUseCase.call(),
        ).thenAnswer((_) async => SuccessResponse(null));
        return ProfileCubit(mockLogoutUseCase);
      },
      act: (cubit) => cubit.doEvent(const LogoutEvent()),
      expect: () => [
        ProfileState(logoutState: BaseState.loading()),
        ProfileState(logoutState: BaseState.success(null)),
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
        return ProfileCubit(mockLogoutUseCase);
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
}

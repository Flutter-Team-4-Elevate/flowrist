import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/change_password_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/get_profile_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/logout_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/update_profile_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  ProfileCubit(
    this._logoutUseCase,
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._changePasswordUseCase,
  ) : super(const ProfileState());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case LogoutEvent():
        _logout();
      case GetProfileEvent():
        _getProfile();
      case UpdateProfileEvent(request: final request):
        _updateProfile(request);
      case ChangePasswordEvent(request: final request):
        _changePassword(request);
    }
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: BaseState.loading()));
    final response = await _logoutUseCase.call();
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(logoutState: BaseState.success(null)));
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(logoutState: BaseState.error(message)));
    }
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(profileState: BaseState.loading()));
    final response = await _getProfileUseCase.call();
    switch (response) {
      case SuccessResponse(data: final user):
        if (user != null) {
          emit(state.copyWith(profileState: BaseState.success(user)));
        } else {
          emit(
            state.copyWith(
              profileState: BaseState.error('No profile data found'),
            ),
          );
        }
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(profileState: BaseState.error(message)));
    }
  }

  Future<void> _updateProfile(UpdateProfileRequestDto request) async {
    emit(state.copyWith(updateProfileState: BaseState.loading()));
    final response = await _updateProfileUseCase.call(request);
    switch (response) {
      case SuccessResponse(data: final updatedUser):
        if (updatedUser != null) {
          emit(
            state.copyWith(
              updateProfileState: BaseState.success(updatedUser),
              profileState: BaseState.success(updatedUser),
            ),
          );
        } else {
          emit(
            state.copyWith(
              updateProfileState: BaseState.error(
                'Failed to update profile data',
              ),
            ),
          );
        }
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(updateProfileState: BaseState.error(message)));
    }
  }

  Future<void> _changePassword(ChangePasswordRequestDto request) async {
    emit(state.copyWith(changePasswordState: BaseState.loading()));
    final response = await _changePasswordUseCase.call(request);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(changePasswordState: BaseState.success(null)));
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(changePasswordState: BaseState.error(message)));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';

class ProfileState extends Equatable {
  final BaseState<void> logoutState;
  final BaseState<UserProfileEntity> profileState;
  final BaseState<UserProfileEntity> updateProfileState;
  final BaseState<void> changePasswordState;

  const ProfileState({
    this.logoutState = const BaseState.initial(),
    this.profileState = const BaseState.initial(),
    this.updateProfileState = const BaseState.initial(),
    this.changePasswordState = const BaseState.initial(),
  });

  ProfileState copyWith({
    BaseState<void>? logoutState,
    BaseState<UserProfileEntity>? profileState,
    BaseState<UserProfileEntity>? updateProfileState,
    BaseState<void>? changePasswordState,
  }) {
    return ProfileState(
      logoutState: logoutState ?? this.logoutState,
      profileState: profileState ?? this.profileState,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object?> get props => [
    logoutState,
    profileState,
    updateProfileState,
    changePasswordState,
  ];
}

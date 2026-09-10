import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';

class ProfileState extends Equatable {
  final BaseState<void> logoutState;

  const ProfileState({
    this.logoutState = const BaseState.initial(),
  });

  ProfileState copyWith({
    BaseState<void>? logoutState,
  }) {
    return ProfileState(
      logoutState: logoutState ?? this.logoutState,
    );
  }

  @override
  List<Object?> get props => [logoutState];
}
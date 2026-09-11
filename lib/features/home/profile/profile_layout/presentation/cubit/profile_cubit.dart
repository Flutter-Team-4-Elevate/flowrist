import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/logout_use_case.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final LogoutUseCase _logoutUseCase;

  ProfileCubit(this._logoutUseCase) : super(const ProfileState());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case LogoutEvent():
        _logout();
    }
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: BaseState<void>.loading()));

    final response = await _logoutUseCase.call();

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(logoutState: BaseState<void>.success(null)));
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(logoutState: BaseState<void>.error(message)));
    }
  }
}

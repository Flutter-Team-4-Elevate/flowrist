import 'dart:async';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';
import 'package:flowrist/features/auth/domain/use_cases/login_use_case.dart';
import 'package:injectable/injectable.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final SessionService _sessionService;

  LoginCubit(this._loginUseCase, this._sessionService)
    : super(LoginState.initial());

  final StreamController<LoginUIEvent> _uiEventController =
      StreamController.broadcast();

  Stream<LoginUIEvent> get uiStream => _uiEventController.stream;

  Future<void> doEvent(LoginEvent event) async {
    switch (event) {
      case LoginSubmitted():
        await _login(event);

      case RememberMeChanged():
        await _rememberMeChanged(event);

      case FormValidityChanged():
        await _formValidityChanged(event);

      case ContinueAsGuest():
        await _continueAsGuest();
    }
  }

  Future<void> _rememberMeChanged(RememberMeChanged event) async {
    emit(state.copyWith(rememberMe: event.value));
  }

  Future<void> _formValidityChanged(FormValidityChanged event) async {
    emit(state.copyWith(isFormValid: event.isValid));
  }

  Future<void> _login(LoginSubmitted event) async {
    if (!state.isFormValid) {
      return;
    }
    emit(
      state.copyWith(
        login: state.login.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    final params = LoginParams(
      email: event.email,
      password: event.password,
      fcmToken: '',
    );

    final result = await _loginUseCase(params, state.rememberMe);

    switch (result) {
      case SuccessResponse<LoginEntity>():
        emit(
          state.copyWith(
            login: state.login.copyWith(isLoading: false, data: result.data),
          ),
        );
        _uiEventController.add(ShowMessage('loginSuccessfully'));
        _uiEventController.add(LoginSuccess());

      case ErrorResponse<LoginEntity>():
        emit(
          state.copyWith(
            login: state.login.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        _uiEventController.add(ShowMessage(result.errorMessage));
    }
  }

  Future<void> _continueAsGuest() async {
    await _sessionService.setGuestMode(true);
    await _sessionService.setRememberMe(false);

    _uiEventController.add(GuestLoginSuccess());
  }

  @override
  Future<void> close() {
    _uiEventController.close();
    return super.close();
  }
}

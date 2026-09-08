import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../domain/use_cases/forget_password_usecase.dart';
import '../../../domain/use_cases/reset_password_usecase.dart';
import '../../../domain/use_cases/verify_otp_usecase.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

@injectable
class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  Timer? _timer;

  ForgetPasswordBloc(
    this._forgetPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
  ) : super(ForgetPasswordState()) {
    on<CheckEmailEvent>(_onCheckEmail);
    on<ResendOtpEvent>(_onResendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
    on<StartOtpTimerEvent>(_onStartOtpTimer);
    on<TickOtpTimerEvent>(_onTickOtpTimer);
  }

  Future<void> _onCheckEmail(
    CheckEmailEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.checkEmail,
        errorMessage: null,
      ),
    );

    final BaseResponse result = await _forgetPasswordUseCase.execute(
      email: event.email,
    );

    if (result is SuccessResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          step: ForgetPasswordStep.otp,
          operation: ForgetPasswordOperation.checkEmail,
          email: event.email,
          remainingSeconds: 30,
          errorMessage: null,
        ),
      );

      add(const StartOtpTimerEvent());
    } else if (result is ErrorResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.checkEmail,
          errorMessage: result.errorMessage,
        ),
      );
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (state.email == null || !state.canResend) {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.resendOtp,
        errorMessage: null,
      ),
    );

    final BaseResponse result = await _forgetPasswordUseCase.execute(
      email: state.email!,
    );

    if (result is SuccessResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resendOtp,
          remainingSeconds: 30,
          errorMessage: null,
        ),
      );

      add(const StartOtpTimerEvent());
    } else if (result is ErrorResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resendOtp,
          errorMessage: result.errorMessage,
        ),
      );
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (state.email == null) {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.verifyOtp,
        otp: event.otp,
        errorMessage: null,
      ),
    );

    final BaseResponse result = await _verifyOtpUseCase.execute(
      email: state.email!,
      otp: event.otp,
    );

    if (result is SuccessResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          step: ForgetPasswordStep.resetPassword,
          operation: ForgetPasswordOperation.verifyOtp,
          errorMessage: null,
        ),
      );
    } else if (result is ErrorResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.verifyOtp,
          errorMessage: result.errorMessage,
        ),
      );
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (state.email == null) {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.resetPassword,
        errorMessage: null,
      ),
    );

    final BaseResponse result = await _resetPasswordUseCase.execute(
      email: state.email!,
      newPassword: event.password,
    );

    if (result is SuccessResponse) {
      _timer?.cancel();

      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resetPassword,
          errorMessage: null,
        ),
      );
    } else if (result is ErrorResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resetPassword,
          errorMessage: result.errorMessage,
        ),
      );
    }
  }

  void _onStartOtpTimer(
    StartOtpTimerEvent event,
    Emitter<ForgetPasswordState> emit,
  ) {
    _timer?.cancel();

    emit(state.copyWith(remainingSeconds: 30));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickOtpTimerEvent());
    });
  }

  void _onTickOtpTimer(
    TickOtpTimerEvent event,
    Emitter<ForgetPasswordState> emit,
  ) {
    if (state.remainingSeconds <= 1) {
      _timer?.cancel();

      emit(state.copyWith(remainingSeconds: 0));

      return;
    }

    emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

import 'package:equatable/equatable.dart';

sealed class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class CheckEmailEvent extends ForgetPasswordEvent {
  final String email;

  const CheckEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class OtpChangedEvent extends ForgetPasswordEvent {
  final String otp;

  const OtpChangedEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class ResendOtpEvent extends ForgetPasswordEvent {
  const ResendOtpEvent();
}

class VerifyOtpEvent extends ForgetPasswordEvent {
  final String otp;

  const VerifyOtpEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String password;

  const ResetPasswordEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class StartOtpTimerEvent extends ForgetPasswordEvent {
  const StartOtpTimerEvent();
}

class TickOtpTimerEvent extends ForgetPasswordEvent {
  const TickOtpTimerEvent();
}

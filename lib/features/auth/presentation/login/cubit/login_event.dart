sealed class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class RememberMeChanged extends LoginEvent {
  final bool value;

  RememberMeChanged(this.value);
}

class FormValidityChanged extends LoginEvent {
  final bool isValid;

  FormValidityChanged(this.isValid);
}

class ContinueAsGuest extends LoginEvent {}

sealed class LoginUIEvent {}

class ShowMessage extends LoginUIEvent {
  final String message;

  ShowMessage(this.message);
}

class LoginSuccess extends LoginUIEvent {}

class GuestLoginSuccess extends LoginUIEvent {}

import 'package:flowrist/features/auth/data/models/register_request_dto.dart';

sealed class SignUpEvent {}

class SignUpSubmittedEvent extends SignUpEvent {
  final RegisterRequestDto request;

  SignUpSubmittedEvent(this.request);
}

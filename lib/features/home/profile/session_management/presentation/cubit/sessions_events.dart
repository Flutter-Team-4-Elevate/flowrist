import 'package:equatable/equatable.dart';

sealed class SessionsEvents extends Equatable {
  const SessionsEvents();

  @override
  List<Object?> get props => [];
}

final class GetSessionsEvent extends SessionsEvents {
  const GetSessionsEvent();
}

final class RevokeSessionEvent extends SessionsEvents {
  final String sessionId;

  const RevokeSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

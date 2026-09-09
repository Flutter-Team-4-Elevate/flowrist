import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';

class SessionsState extends Equatable {
  final BaseState<List<SessionEntity>> sessions;
  final String? revokingSessionId;
  final String? successMessage;

  const SessionsState({
    required this.sessions,
    this.revokingSessionId,
    this.successMessage,
  });

  factory SessionsState.initial() {
    return const SessionsState(
      sessions: BaseState<List<SessionEntity>>(
        isLoading: false,
        errorMessage: null,
        data: null,
      ),
    );
  }

  SessionsState copyWith({
    BaseState<List<SessionEntity>>? sessions,
    String? revokingSessionId,
    bool? clearRevokingId,
    String? successMessage,
    bool? clearSuccessMessage,
  }) {
    return SessionsState(
      sessions: sessions ?? this.sessions,
      revokingSessionId: clearRevokingId == true
          ? null
          : (revokingSessionId ?? this.revokingSessionId),
      successMessage: clearSuccessMessage == true
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [sessions, revokingSessionId, successMessage];
}

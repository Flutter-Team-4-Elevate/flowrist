import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flowrist/features/home/profile/session_management/domain/use_cases/get_sessions_use_case.dart';
import 'package:flowrist/features/home/profile/session_management/domain/use_cases/revoke_session_use_case.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_events.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SessionsCubit extends Cubit<SessionsState> {
  final GetSessionsUseCase _getSessionsUseCase;
  final RevokeSessionUseCase _revokeSessionUseCase;

  SessionsCubit(this._getSessionsUseCase, this._revokeSessionUseCase)
    : super(SessionsState.initial());

  Future<void> doEvent(SessionsEvents event) async {
    switch (event) {
      case GetSessionsEvent():
        await _getSessions();
      case RevokeSessionEvent():
        await _revokeSession(event.sessionId);
    }
  }

  Future<void> _getSessions() async {
    emit(
      state.copyWith(
        sessions: state.sessions.copyWith(isLoading: true, errorMessage: null),
        clearSuccessMessage: true,
      ),
    );

    final result = await _getSessionsUseCase();

    switch (result) {
      case SuccessResponse<List<SessionEntity>>():
        emit(
          state.copyWith(
            sessions: state.sessions.copyWith(
              isLoading: false,
              data: result.data ?? [],
              errorMessage: null,
            ),
          ),
        );
      case ErrorResponse<List<SessionEntity>>():
        emit(
          state.copyWith(
            sessions: state.sessions.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _revokeSession(String sessionId) async {
    emit(
      state.copyWith(revokingSessionId: sessionId, clearSuccessMessage: true),
    );

    final result = await _revokeSessionUseCase(sessionId);

    switch (result) {
      case SuccessResponse<void>():
        final currentList = state.sessions.data ?? [];
        final updatedList = currentList
            .where((session) => session.id != sessionId)
            .toList();

        emit(
          state.copyWith(
            clearRevokingId: true,
            sessions: state.sessions.copyWith(data: updatedList),
            successMessage: AppConstants.sessionRevokedSuccessfully,
          ),
        );
      case ErrorResponse<void>():
        emit(
          state.copyWith(
            clearRevokingId: true,
            sessions: state.sessions.copyWith(
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }
}

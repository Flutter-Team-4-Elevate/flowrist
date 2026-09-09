import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionsState', () {
    test('initial state has correct default values', () {
      final state = SessionsState.initial();

      expect(state.sessions.isLoading, isFalse);
      expect(state.sessions.errorMessage, isNull);
      expect(state.sessions.data, isNull);
      expect(state.revokingSessionId, isNull);
      expect(state.successMessage, isNull);
    });

    test('supports value equality', () {
      expect(SessionsState.initial(), equals(SessionsState.initial()));
    });

    test('copyWith updates state correctly and supports clearing fields', () {
      final state = SessionsState.initial();

      final updatedState = state.copyWith(
        revokingSessionId: 'sess_123',
        successMessage: 'Done',
      );

      expect(updatedState.revokingSessionId, equals('sess_123'));
      expect(updatedState.successMessage, equals('Done'));

      final clearedState = updatedState.copyWith(
        clearRevokingId: true,
        clearSuccessMessage: true,
      );

      expect(clearedState.revokingSessionId, isNull);
      expect(clearedState.successMessage, isNull);
    });
  });
}

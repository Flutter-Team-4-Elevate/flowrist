import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_state.dart';

void main() {
  const tUserEntity = UserEntity(
    id: '123',
    name: 'Ali Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

  group('SignUpState Unit Tests', () {
    test('should instantiate SignUpState with correct properties', () {
      // Arrange & Act
      final state = BaseState<UserEntity>(
        isLoading: false,
        errorMessage: null,
        data: tUserEntity,
      );

      // Assert
      expect(state, isA<SignUpState>());
      expect(state.isLoading, equals(false));
      expect(state.errorMessage, isNull);
      expect(state.data, equals(tUserEntity));
    });

    test('copyWith should update properties correctly', () {
      // Arrange
      final initialState = BaseState<UserEntity>(
        isLoading: false,
        errorMessage: null,
        data: null,
      );

      // Act
      final updatedState = initialState.copyWith(
        isLoading: true,
        errorMessage: 'Some error',
      );

      // Assert
      expect(updatedState.isLoading, equals(true));
      expect(updatedState.errorMessage, equals('Some error'));
      expect(updatedState.data, isNull);
    });
  });
}

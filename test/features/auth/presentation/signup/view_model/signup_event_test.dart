import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_event.dart';

void main() {
  const tRequestDto = RegisterRequestDto(
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
    gender: 0,
    password: 'Password123!',
    confirmPassword: 'Password123!',
    fcmToken: 'token',
    notificationStatus: 1,
  );

  group('SignUpEvent Unit Tests', () {
    test(
      'SignUpSubmittedEvent should instantiate correctly and hold request',
      () {
        // Act
        final event = SignUpSubmittedEvent(tRequestDto);

        // Assert
        expect(event, isA<SignUpEvent>());
        expect(event.request, equals(tRequestDto));
        expect(event.request.firstName, equals('Ali'));
        expect(event.request.email, equals('ali@example.com'));
      },
    );
  });
}

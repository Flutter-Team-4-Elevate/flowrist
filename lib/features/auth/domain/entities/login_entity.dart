import 'package:flowrist/features/auth/domain/entities/user_entity.dart';

class LoginEntity {
  final UserEntity user;
  final String token;
  final String refreshToken;

  const LoginEntity({
    required this.user,
    required this.token,
    required this.refreshToken,
  });
}

class LoginParams {
  final String email;
  final String password;
  final String fcmToken;

  const LoginParams({
    required this.email,
    required this.password,
    required this.fcmToken,
  });
}

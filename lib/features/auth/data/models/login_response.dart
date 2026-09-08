import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool status;
  final int code;
  final String message;
  final LoginData data;

  const LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
  LoginEntity toEntity() {
    return LoginEntity(
      user: UserEntity(
        id: data.user.id,
        email: data.user.email,
        phone: data.user.phone,
        name: data.user.name,
      ),
      token: data.token,
      refreshToken: data.refreshToken,
    );
  }
}

@JsonSerializable()
class LoginData {
  final LoginUser user;
  final String token;
  final String refreshToken;

  const LoginData({
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginUser {
  final String id;
  final String email;
  final String phone;
  final String name;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String gender;
  final String notificationStatus;

  const LoginUser({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
    required this.notificationStatus,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequestDto {
  @JsonKey(name: 'FirstName')
  final String firstName;
  @JsonKey(name: 'LastName')
  final String lastName;
  final String email;
  final String phone;
  final int gender;
  final String password;
  final String confirmPassword;
  final String fcmToken;
  final int notificationStatus;

  const RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    required this.fcmToken,
    required this.notificationStatus,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}

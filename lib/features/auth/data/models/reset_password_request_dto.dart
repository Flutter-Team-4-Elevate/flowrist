import 'package:json_annotation/json_annotation.dart';
part 'reset_password_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ResetPasswordRequestDto {
  final String otpToken;
  final String password;
  final String confirmPassword;

  const ResetPasswordRequestDto({
    required this.otpToken,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}

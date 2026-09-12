import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ResetPasswordRequestDto {
  final String email;
  final String newPassword;

  const ResetPasswordRequestDto({
    required this.email,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}

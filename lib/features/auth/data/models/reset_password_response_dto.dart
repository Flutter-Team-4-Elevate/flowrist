import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_dto.g.dart';

@JsonSerializable()
class ResetPasswordResponseDto {
  final bool status;
  final String? message;

  const ResetPasswordResponseDto({
    required this.status,
    this.message,
  });

  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseDtoToJson(this);
}

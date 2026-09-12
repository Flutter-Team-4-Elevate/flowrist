import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_dto.g.dart';

@JsonSerializable()
class ForgetPasswordResponseDto {
  final bool status;
  final String? message;

  const ForgetPasswordResponseDto({
    required this.status,
    this.message,
  });

  factory ForgetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseDtoToJson(this);
}

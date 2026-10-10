import 'package:json_annotation/json_annotation.dart';

part 'change_password_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ChangePasswordResponseDto {
  final bool? status;
  final int? code;
  final String? message;

  const ChangePasswordResponseDto({this.status, this.code, this.message});

  factory ChangePasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseDtoFromJson(json);
}

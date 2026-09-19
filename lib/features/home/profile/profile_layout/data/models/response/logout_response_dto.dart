import 'package:json_annotation/json_annotation.dart';

part 'logout_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class LogoutResponseDto {
  final bool? status;
  final int? code;
  final String? message;

  const LogoutResponseDto({this.status, this.code, this.message});

  factory LogoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseDtoFromJson(json);
}

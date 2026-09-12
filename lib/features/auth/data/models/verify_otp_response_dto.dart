import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response_dto.g.dart';

@JsonSerializable()
class VerifyOtpResponseDto {
  final bool status;
  final String? message;
  final dynamic data;

  const VerifyOtpResponseDto({
    required this.status,
    this.message,
    this.data,
  });

  factory VerifyOtpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseDtoToJson(this);
}

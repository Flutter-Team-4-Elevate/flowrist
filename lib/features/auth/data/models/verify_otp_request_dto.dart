import 'package:json_annotation/json_annotation.dart';
part 'verify_otp_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class VerifyOtpRequestDto {
  final String email;
  final String otp;

  const VerifyOtpRequestDto({required this.email, required this.otp});

  Map<String, dynamic> toJson() => _$VerifyOtpRequestDtoToJson(this);
}

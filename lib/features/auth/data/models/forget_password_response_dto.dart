import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_dto.g.dart';

@JsonSerializable()
class ForgetPasswordResponseDto {
  final String? message;

  const ForgetPasswordResponseDto({this.message});

  factory ForgetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseDtoToJson(this);
}

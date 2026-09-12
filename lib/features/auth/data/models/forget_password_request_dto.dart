import 'package:json_annotation/json_annotation.dart';
part 'forget_password_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ForgetPasswordRequestDto {
  final String email;

  const ForgetPasswordRequestDto({required this.email});

  Map<String, dynamic> toJson() => _$ForgetPasswordRequestDtoToJson(this);
}

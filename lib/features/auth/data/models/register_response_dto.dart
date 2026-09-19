import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  final String? message;
  final RegisterDataDto? data;

  const RegisterResponseDto({this.message, this.data});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);
}

@JsonSerializable()
class RegisterDataDto {
  final UserDto? user;
  final String? token;

  const RegisterDataDto({this.user, this.token});

  factory RegisterDataDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataDtoToJson(this);
}

@JsonSerializable()
class UserDto {
  final String? id;
  final String? email;
  final String? phone;
  final String? name;

  const UserDto({this.id, this.email, this.phone, this.name});

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

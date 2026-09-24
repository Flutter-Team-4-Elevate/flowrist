import 'package:json_annotation/json_annotation.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class UserProfileDto {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? gender;
  final String? profilePictureUrl;

  const UserProfileDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class UserProfileResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final UserProfileDto? data;

  const UserProfileResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory UserProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseDtoFromJson(json);
}

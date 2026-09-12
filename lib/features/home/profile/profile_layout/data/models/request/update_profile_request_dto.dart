import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class UpdateProfileRequestDto {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final int gender;
  final String profilePictureUrl;

  const UpdateProfileRequestDto({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}
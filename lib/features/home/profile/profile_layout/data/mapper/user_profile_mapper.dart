import 'package:flowrist/features/home/profile/profile_layout/data/models/response/user_profile_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';

extension UserProfileDtoMapper on UserProfileDto {
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      gender: gender ?? 0,
      profilePictureUrl: profilePictureUrl ?? '',
    );
  }
}

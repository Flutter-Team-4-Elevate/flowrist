import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';

sealed class ProfileEvents {
  const ProfileEvents();
}

final class LogoutEvent extends ProfileEvents {
  const LogoutEvent();
}

final class GetProfileEvent extends ProfileEvents {
  const GetProfileEvent();
}

final class UpdateProfileEvent extends ProfileEvents {
  final UpdateProfileRequestDto request;
  const UpdateProfileEvent(this.request);
}

final class ChangePasswordEvent extends ProfileEvents {
  final ChangePasswordRequestDto request;
  const ChangePasswordEvent(this.request);
}

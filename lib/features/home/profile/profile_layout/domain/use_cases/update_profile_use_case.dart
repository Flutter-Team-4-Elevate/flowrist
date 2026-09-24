import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;
  UpdateProfileUseCase(this._repository);

  Future<BaseResponse<UserProfileEntity>> call(
    UpdateProfileRequestDto request,
  ) async {
    return await _repository.updateProfile(request);
  }
}

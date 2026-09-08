import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<BaseResponse<UserEntity>> call(RegisterRequestDto request) async {
    return await _repository.register(request);
  }
}

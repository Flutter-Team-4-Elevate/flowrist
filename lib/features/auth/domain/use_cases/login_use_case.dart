import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;
  LoginUseCase(this._authRepository);
  Future<BaseResponse<LoginEntity>> call(LoginParams params, bool rememberMe) {
    return _authRepository.login(params, rememberMe);
  }
}

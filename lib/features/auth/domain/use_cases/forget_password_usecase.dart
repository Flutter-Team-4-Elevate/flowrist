import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepository _repository;

  ForgetPasswordUseCase(this._repository);

  Future<BaseResponse<void>> execute({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}

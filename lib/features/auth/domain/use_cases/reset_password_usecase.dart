import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<BaseResponse<void>> execute({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    return _repository.resetPassword(
      otpToken: otpToken,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
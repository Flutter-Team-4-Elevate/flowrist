import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<BaseResponse<void>> execute({
    required String email,
    required String otp,
  }) {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}

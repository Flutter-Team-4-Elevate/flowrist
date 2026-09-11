import 'package:flowrist/config/base_response/base_response.dart';

abstract interface class ProfileRepository {
  Future<BaseResponse<void>> logout();
}

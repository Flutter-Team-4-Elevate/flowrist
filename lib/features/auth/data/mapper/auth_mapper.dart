import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';

abstract final class AuthMapper {
  static UserEntity toUserEntity(RegisterResponseDto dto) {
    final user = dto.data?.user;
    return UserEntity(
      id: user?.id ?? '',
      email: user?.email ?? '',
      phone: user?.phone ?? '',
      name: user?.name ?? '',
    );
  }
}

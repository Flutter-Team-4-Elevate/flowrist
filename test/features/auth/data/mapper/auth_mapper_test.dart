import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/auth/data/mapper/auth_mapper.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';

void main() {
  const tUserDto = UserDto(
    id: '123',
    name: 'Ali Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

  const tResponseDto = RegisterResponseDto(
    message: 'Success',
    data: RegisterDataDto(user: tUserDto, token: 'jwt_token_example'),
  );

  group('AuthMapper Unit Tests', () {
    test('should correctly map RegisterResponseDto to UserEntity', () {
      final result = AuthMapper.toUserEntity(tResponseDto);

      expect(result.id, equals('123'));
      expect(result.name, equals('Ali Ibrahim'));
      expect(result.email, equals('ali@example.com'));
      expect(result.phone, equals('01000000000'));
    });

    test('should return empty strings when DTO fields are null', () {
      const emptyDto = RegisterResponseDto(data: null);

      final result = AuthMapper.toUserEntity(emptyDto);

      expect(result.id, equals(''));
      expect(result.name, equals(''));
      expect(result.email, equals(''));
      expect(result.phone, equals(''));
    });
  });
}

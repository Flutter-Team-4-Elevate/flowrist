import 'package:flowrist/features/home/profile/session_management/data/mapper/session_mapper.dart';
import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionMapper', () {
    test(
      'should map SessionsResponseDto to List<SessionEntity> filtering out invalid ids',
      () {
        const dto = SessionsResponseDto(
          data: [
            SessionItemDto(
              id: 'sess_1',
              deviceName: 'Pixel 8',
              ipAddress: '192.168.1.1',
              location: 'Cairo',
              createdAt: '2026-09-01',
              lastUsedAt: '2026-09-04',
              isCurrent: true,
            ),
            SessionItemDto(id: null, deviceName: 'Unknown Device'),
            SessionItemDto(id: '', deviceName: 'Empty ID Device'),
          ],
        );

        final result = SessionMapper.toSessionEntityList(dto);

        expect(result.length, equals(1));
        expect(result.first.id, equals('sess_1'));
        expect(result.first.deviceName, equals('Pixel 8'));
        expect(result.first.ipAddress, equals('192.168.1.1'));
        expect(result.first.location, equals('Cairo'));
        expect(result.first.createdAt, equals('2026-09-01'));
        expect(result.first.lastUsedAt, equals('2026-09-04'));
        expect(result.first.isCurrent, isTrue);
      },
    );

    test(
      'should return empty list when data in SessionsResponseDto is null',
      () {
        const dto = SessionsResponseDto(data: null);

        final result = SessionMapper.toSessionEntityList(dto);

        expect(result, isEmpty);
      },
    );

    test(
      'should provide default fallback values for null properties in SessionItemDto',
      () {
        const dto = SessionsResponseDto(
          data: [SessionItemDto(id: 'sess_fallback')],
        );

        final result = SessionMapper.toSessionEntityList(dto);

        expect(result.length, equals(1));
        expect(result.first.id, equals('sess_fallback'));
        expect(result.first.deviceName, equals(''));
        expect(result.first.ipAddress, equals(''));
        expect(result.first.location, equals(''));
        expect(result.first.createdAt, equals(''));
        expect(result.first.lastUsedAt, equals(''));
        expect(result.first.isCurrent, isFalse);
      },
    );
  });
}

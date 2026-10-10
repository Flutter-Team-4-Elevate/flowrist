import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';

abstract final class SessionMapper {
  static List<SessionEntity> toSessionEntityList(SessionsResponseDto dto) {
    final items = dto.data ?? [];
    return items
        .where((item) => item.id != null && item.id!.isNotEmpty)
        .map(
          (item) => SessionEntity(
            id: item.id!,
            deviceName: item.deviceName ?? '',
            ipAddress: item.ipAddress ?? '',
            location: item.location ?? '',
            createdAt: item.createdAt ?? '',
            lastUsedAt: item.lastUsedAt ?? '',
            isCurrent: item.isCurrent ?? false,
          ),
        )
        .toList();
  }
}

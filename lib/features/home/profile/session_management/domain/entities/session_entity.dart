import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String id;
  final String deviceName;
  final String ipAddress;
  final String location;
  final String createdAt;
  final String lastUsedAt;
  final bool isCurrent;

  const SessionEntity({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    required this.location,
    required this.createdAt,
    required this.lastUsedAt,
    required this.isCurrent,
  });

  @override
  List<Object?> get props => [
    id,
    deviceName,
    ipAddress,
    location,
    createdAt,
    lastUsedAt,
    isCurrent,
  ];
}

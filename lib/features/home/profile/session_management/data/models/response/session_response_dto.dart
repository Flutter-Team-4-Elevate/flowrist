import 'package:json_annotation/json_annotation.dart';

part 'session_response_dto.g.dart';

@JsonSerializable()
class SessionsResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<SessionItemDto>? data;
  final dynamic pagination;
  final dynamic errors;

  const SessionsResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory SessionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SessionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionsResponseDtoToJson(this);
}

@JsonSerializable()
class SessionItemDto {
  final String? id;
  final String? deviceName;
  final String? ipAddress;
  final String? location;
  final String? createdAt;
  final String? lastUsedAt;
  final bool? isCurrent;

  const SessionItemDto({
    this.id,
    this.deviceName,
    this.ipAddress,
    this.location,
    this.createdAt,
    this.lastUsedAt,
    this.isCurrent,
  });

  factory SessionItemDto.fromJson(Map<String, dynamic> json) =>
      _$SessionItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionItemDtoToJson(this);
}

@JsonSerializable()
class RevokeSessionResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final dynamic data;
  final dynamic pagination;
  final dynamic errors;

  const RevokeSessionResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory RevokeSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RevokeSessionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RevokeSessionResponseDtoToJson(this);
}

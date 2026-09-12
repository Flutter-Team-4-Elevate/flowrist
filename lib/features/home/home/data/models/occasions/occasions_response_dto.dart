import 'package:flowrist/features/home/shared/pagination_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'occasions_response_dto.g.dart';

@JsonSerializable()
class OccasionsResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<OccasionDto>? data;
  final PaginationDto? pagination;

  const OccasionsResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  factory OccasionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OccasionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionsResponseDtoToJson(this);
}

@JsonSerializable()
class OccasionDto {
  final String? id;
  final String? name;
  final String? imageUrl;
  final int? displayOrder;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? lastChangedBy;

  const OccasionDto({
    this.id,
    this.name,
    this.imageUrl,
    this.displayOrder,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastChangedBy,
  });

  factory OccasionDto.fromJson(Map<String, dynamic> json) =>
      _$OccasionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionDtoToJson(this);
}

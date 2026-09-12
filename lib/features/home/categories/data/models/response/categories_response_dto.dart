import 'package:flowrist/features/home/shared/pagination_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response_dto.g.dart';

@JsonSerializable()
class CategoriesResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<CategoryDto>? data;
  final PaginationDto? pagination;

  const CategoriesResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseDtoToJson(this);
}

@JsonSerializable()
class CategoryDto {
  final String? id;
  final String? name;
  final String? iconUrl;
  final int? displayOrder;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? lastChangedBy;

  const CategoryDto({
    this.id,
    this.name,
    this.iconUrl,
    this.displayOrder,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.lastChangedBy,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}

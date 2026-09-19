import 'package:json_annotation/json_annotation.dart';

part 'search_response_dto.g.dart';

@JsonSerializable()
class SearchResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<SearchProductItemDto>? data;
  final SearchPaginationDto? pagination;
  final dynamic errors;

  const SearchResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory SearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseDtoToJson(this);
}

@JsonSerializable()
class SearchProductItemDto {
  final String? id;
  final String? name;
  final num? price;
  final num? discountPercentage;
  final num? discountPrice;
  final bool? inStock;
  final String? categoryId;
  final String? categoryName;
  final String? imageUrl;
  final String? createdAt;

  const SearchProductItemDto({
    this.id,
    this.name,
    this.price,
    this.discountPercentage,
    this.discountPrice,
    this.inStock,
    this.categoryId,
    this.categoryName,
    this.imageUrl,
    this.createdAt,
  });

  factory SearchProductItemDto.fromJson(Map<String, dynamic> json) =>
      _$SearchProductItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchProductItemDtoToJson(this);
}

@JsonSerializable()
class SearchPaginationDto {
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  const SearchPaginationDto({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory SearchPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$SearchPaginationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPaginationDtoToJson(this);
}

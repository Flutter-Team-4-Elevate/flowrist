import 'package:flowrist/features/home/shared/pagination_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProductsResponseDto {
  final bool? status;
  final int? code;
  final String? message;

  @JsonKey(fromJson: _dataFromJson)
  final List<ProductDto>? data;
  final PaginationDto? pagination;

  const ProductsResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseDtoFromJson(json);

  static List<ProductDto>? _dataFromJson(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map((e) => ProductDto.fromJson(e))
          .toList();
    }
    return null;
  }
}

@JsonSerializable(createToJson: false)
class ProductDto {
  final String? id;
  final String? name;
  final double? price;
  final double? discountPercentage;
  final double? discountPrice;
  final bool? inStock;
  final String? categoryId;
  final String? categoryName;
  final String? imageUrl;
  final String? createdAt;

  const ProductDto({
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

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}

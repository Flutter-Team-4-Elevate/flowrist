import 'package:json_annotation/json_annotation.dart';

part 'product_details_request_dto.g.dart';

@JsonSerializable()
class ProductDetailsRequestDto {
  final String id;
  final String name;
  final double price;
  final double? discountedPrice;
  final double? discountPercent;
  final bool inStock;
  final List<String> images;
  final String description;
  final List<String> includes;
  final String availabilityStatus;
  final int availableStock;
  final List<String> categoryIds;
  final List<String> occasionIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastChangedBy;

  const ProductDetailsRequestDto({
    required this.id,
    required this.name,
    required this.price,
    this.discountedPrice,
    this.discountPercent,
    required this.inStock,
    required this.images,
    required this.description,
    required this.includes,
    required this.availabilityStatus,
    required this.availableStock,
    required this.categoryIds,
    required this.occasionIds,
    required this.createdAt,
    required this.updatedAt,
    required this.lastChangedBy,
  });

  factory ProductDetailsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsRequestDtoToJson(this);
}

import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:json_annotation/json_annotation.dart';


part 'product_details_response_dto.g.dart';

@JsonSerializable()
class ProductDetailsResponseDto {
  final bool status;
  final int code;
  final String message;
  final ProductDetailsRequestDto? data;

  const ProductDetailsResponseDto({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ProductDetailsResponseDto.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ProductDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductDetailsResponseDtoToJson(this);
}
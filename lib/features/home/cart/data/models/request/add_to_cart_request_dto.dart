import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class AddToCartRequestDto {
  final String productId;
  final int quantity;

  const AddToCartRequestDto({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => _$AddToCartRequestDtoToJson(this);
}
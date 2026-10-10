import 'package:json_annotation/json_annotation.dart';

part 'update_cart_item_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class UpdateCartItemRequestDto {
  final int quantity;

  const UpdateCartItemRequestDto({required this.quantity});

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestDtoToJson(this);
}

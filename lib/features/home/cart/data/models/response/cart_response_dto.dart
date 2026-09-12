import 'package:json_annotation/json_annotation.dart';

part 'cart_response_dto.g.dart';

@JsonSerializable()
class CartResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final CartDataDto? data;

  const CartResponseDto({this.status, this.code, this.message, this.data});

  factory CartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseDtoToJson(this);
}

@JsonSerializable()
class CartDataDto {
  final String? cartId;
  final List<CartItemDto>? items;
  final int? totalQuantity;
  final int? lineCount;
  final num? subtotal;
  final num? deliveryFee;
  final num? total;
  final bool? hasChanges;

  const CartDataDto({
    this.cartId,
    this.items,
    this.totalQuantity,
    this.lineCount,
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.hasChanges,
  });

  factory CartDataDto.fromJson(Map<String, dynamic> json) =>
      _$CartDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataDtoToJson(this);
}

@JsonSerializable()
class CartItemDto {
  final String? itemId;
  final String? productId;
  final String? productName;
  final String? productImage;
  final num? unitPrice;
  final num? priceAtAdd;
  final int? quantity;
  final num? lineSubtotal;
  final int? availableStock;
  final bool? isAvailable;
  final bool? priceChanged;
  final bool? stockChanged;

  const CartItemDto({
    this.itemId,
    this.productId,
    this.productName,
    this.productImage,
    this.unitPrice,
    this.priceAtAdd,
    this.quantity,
    this.lineSubtotal,
    this.availableStock,
    this.isAvailable,
    this.priceChanged,
    this.stockChanged,
  });
  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemDtoToJson(this);
}

import 'package:equatable/equatable.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String cartId;
  final List<CartItemEntity> items;
  final int totalQuantity;
  final int lineCount;
  final num subtotal;
  final num deliveryFee;
  final num total;
  final bool hasChanges;

  const CartEntity({
    required this.cartId,
    required this.items,
    required this.totalQuantity,
    required this.lineCount,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.hasChanges,
  });
  @override
  List<Object?> get props => [
    cartId,
    items,
    totalQuantity,
    lineCount,
    subtotal,
    deliveryFee,
    total,
    hasChanges,
  ];
}

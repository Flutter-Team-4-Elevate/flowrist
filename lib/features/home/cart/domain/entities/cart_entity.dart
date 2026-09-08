import 'package:equatable/equatable.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String cartId;
  final List<CartItemEntity> items;
  final num total;

  const CartEntity({
    required this.cartId,
    required this.items,
    required this.total,
  });

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [cartId, items, totalQuantity, total];
}

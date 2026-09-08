import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

abstract final class CartMapper {
  static CartEntity toCartEntity(CartResponseDto dto) {
    final data = dto.data;

    final items = (data?.items ?? [])
        .where(
          (item) =>
              item.itemId != null &&
              item.itemId!.isNotEmpty &&
              item.productId != null &&
              item.productId!.isNotEmpty,
        )
        .map(
          (item) => CartItemEntity(
            itemId: item.itemId!,
            productId: item.productId!,
            productName: item.productName ?? '',
            productImage: item.productImage ?? '',
            unitPrice: item.unitPrice ?? 0,
            priceAtAdd: item.priceAtAdd ?? 0,
            quantity: item.quantity ?? 1,
            availableStock: item.availableStock ?? 0,
          ),
        )
        .toList();

    return CartEntity(
      cartId: data?.cartId ?? '',
      items: items,
      total: data?.total ?? 0,
    );
  }
}

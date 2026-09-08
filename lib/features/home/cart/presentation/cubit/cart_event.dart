sealed class CartEvent {}

class GetCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;

  AddToCartEvent({required this.productId});
}

class ChangeCartQuantityEvent extends CartEvent {
  final String productId;
  final int delta;

  ChangeCartQuantityEvent({required this.productId, required this.delta});
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  RemoveCartItemEvent({required this.itemId});
}

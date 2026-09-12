sealed class CartEvent {}

class GetCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;

  AddToCartEvent({required this.productId});
}

class ChangeCartQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;

  ChangeCartQuantityEvent({required this.itemId, required this.quantity});
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  RemoveCartItemEvent({required this.itemId});
}

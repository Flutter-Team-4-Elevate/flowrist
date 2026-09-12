sealed class ProductDetailsEvent {}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  GetProductDetailsEvent(this.productId);
}
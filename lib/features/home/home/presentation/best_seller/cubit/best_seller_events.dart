sealed class BestSellerEvents {}

class GetBestSellerProductsEvent extends BestSellerEvents {
  final String categoryId;

  GetBestSellerProductsEvent(this.categoryId);
}

import 'package:equatable/equatable.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final bool isLoading;
  final String? loadingProductId;
  final String? errorMessage;
  final CartEntity? cart;

  const CartState({
    this.isLoading = false,
    this.loadingProductId,
    this.errorMessage,
    this.cart,
  });

  List<CartItemEntity> get items => cart?.items ?? const [];

  Map<String, int> get productQuantityMap => {
    for (final item in items) item.productId: item.quantity,
  };

  int get totalQuantity => cart?.totalQuantity ?? 0;

  int getQuantity(String productId) => productQuantityMap[productId] ?? 0;

  bool isProductLoading(String productId) => loadingProductId == productId;

  CartItemEntity? getItemByProductId(String productId) {
    try {
      return items.firstWhere((element) => element.productId == productId);
    } catch (_) {
      return null;
    }
  }

  CartState copyWith({
    bool? isLoading,
    String? Function()? loadingProductId,
    String? Function()? errorMessage,
    CartEntity? cart,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      loadingProductId: loadingProductId != null
          ? loadingProductId()
          : this.loadingProductId,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      cart: cart ?? this.cart,
    );
  }

  @override
  List<Object?> get props => [isLoading, loadingProductId, errorMessage, cart];
}

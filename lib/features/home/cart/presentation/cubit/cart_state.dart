import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final BaseState<CartEntity> cart;

  final Set<String> addingProductIds;
  final Set<String> loadingItemIds;

  const CartState({
    required this.cart,
    this.addingProductIds = const {},
    this.loadingItemIds = const {},
  });

  CartState.initial()
    : this(
        cart: BaseState.initial(),
        addingProductIds: const {},
        loadingItemIds: const {},
      );

  CartState copyWith({
    BaseState<CartEntity>? cart,
    Set<String>? addingProductIds,
    Set<String>? loadingItemIds,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      addingProductIds: addingProductIds ?? this.addingProductIds,
      loadingItemIds: loadingItemIds ?? this.loadingItemIds,
    );
  }

  CartItemEntity? getCartItem(String productId) {
    final cartData = cart.data;

    if (cartData == null) return null;

    try {
      return cartData.items.firstWhere((item) => item.productId == productId);
    } catch (_) {
      return null;
    }
  }

  int getQuantity(String productId) {
    return getCartItem(productId)?.quantity ?? 0;
  }

  String? getCartItemId(String productId) {
    return getCartItem(productId)?.itemId;
  }

  bool isProductLoading(String productId) {
    final itemId = getCartItemId(productId);

    return itemId != null && loadingItemIds.contains(itemId);
  }

  bool isProductAdding(String productId) {
    return addingProductIds.contains(productId);
  }

  @override
  List<Object?> get props => [cart, addingProductIds, loadingItemIds];
}

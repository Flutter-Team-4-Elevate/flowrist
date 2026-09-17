import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final BaseState<CartEntity> cart;
  final Set<String> addingProductIds;
  final Set<String> loadingItemIds;
  final Map<String, CartItemEntity> itemsMap;

  const CartState({
    required this.cart,
    this.addingProductIds = const {},
    this.loadingItemIds = const {},
    this.itemsMap = const {},
  });

  CartState.initial()
    : this(
        cart: BaseState.initial(),
        addingProductIds: const {},
        loadingItemIds: const {},
        itemsMap: const {},
      );

  CartState copyWith({
    BaseState<CartEntity>? cart,
    Set<String>? addingProductIds,
    Set<String>? loadingItemIds,
    Map<String, CartItemEntity>? itemsMap,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      addingProductIds: addingProductIds ?? this.addingProductIds,
      loadingItemIds: loadingItemIds ?? this.loadingItemIds,
      itemsMap: itemsMap ?? this.itemsMap,
    );
  }

  CartItemEntity? getCartItem(String productId) => itemsMap[productId];

  int getQuantity(String productId) => itemsMap[productId]?.quantity ?? 0;

  String? getCartItemId(String productId) => itemsMap[productId]?.itemId;

  bool isProductLoading(String productId) {
    final itemId = getCartItemId(productId);
    return itemId != null && loadingItemIds.contains(itemId);
  }

  bool isProductAdding(String productId) {
    return addingProductIds.contains(productId);
  }

  @override
  List<Object?> get props => [cart, itemsMap, addingProductIds, loadingItemIds];
}

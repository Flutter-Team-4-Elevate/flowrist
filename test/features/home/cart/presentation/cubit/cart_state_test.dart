import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tCartItem = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Bouquet',
    productImage: 'https://example.com/img.png',
    unitPrice: 50.0,
    priceAtAdd: 50.0,
    quantity: 3,
    lineSubtotal: 150.0,
    availableStock: 5,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  final tCartEntity = CartEntity(
    cartId: 'cart_1',
    items: [tCartItem],
    totalQuantity: 3,
    lineCount: 1,
    subtotal: 150.0,
    deliveryFee: 15.0,
    total: 165.0,
    hasChanges: false,
  );

  group('CartState', () {
    test('initial state has correct default values', () {
      final state = CartState.initial();

      expect(state.cart.isLoading, isFalse);
      expect(state.cart.errorMessage, isNull);
      expect(state.cart.data, isNull);
      expect(state.addingProductIds, isEmpty);
      expect(state.loadingItemIds, isEmpty);
    });

    test('supports value equality', () {
      expect(CartState.initial(), equals(CartState.initial()));
    });

    test('copyWith updates fields correctly', () {
      final state = CartState.initial();

      final updatedState = state.copyWith(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCartEntity,
        ),
        addingProductIds: {'prod_1'},
        loadingItemIds: {'item_1'},
      );

      expect(updatedState.cart.data, equals(tCartEntity));
      expect(updatedState.addingProductIds, contains('prod_1'));
      expect(updatedState.loadingItemIds, contains('item_1'));
    });

    test('helper methods return correct item values when data exists', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCartEntity,
        ),
        addingProductIds: {'prod_1'},
        loadingItemIds: {'item_1'},
      );

      expect(state.getCartItem('prod_1'), equals(tCartItem));
      expect(state.getCartItem('unknown_prod'), isNull);
      expect(state.getQuantity('prod_1'), equals(3));
      expect(state.getQuantity('unknown_prod'), equals(0));
      expect(state.getCartItemId('prod_1'), equals('item_1'));
      expect(state.isProductLoading('prod_1'), isTrue);
      expect(state.isProductAdding('prod_1'), isTrue);
    });
  });
}

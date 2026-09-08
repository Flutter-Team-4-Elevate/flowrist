import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';

void main() {
  const tItem1 = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 2,
    availableStock: 10,
  );

  const tItem2 = CartItemEntity(
    itemId: 'item_2',
    productId: 'prod_2',
    productName: 'Tulips',
    productImage: 'tulips.png',
    unitPrice: 30,
    priceAtAdd: 30,
    quantity: 3,
    availableStock: 5,
  );

  final tCart = CartEntity(
    cartId: 'cart_123',
    items: const [tItem1, tItem2],
    total: 190,
  );

  group('CartState Unit Tests', () {
    test(
      'default state has isLoading=false, loadingProductId=null, errorMessage=null, and cart=null',
      () {
        const state = CartState();

        expect(state.isLoading, isFalse);
        expect(state.loadingProductId, isNull);
        expect(state.errorMessage, isNull);
        expect(state.cart, isNull);
        expect(state.items, isEmpty);
        expect(state.totalQuantity, equals(0));
        expect(state.productQuantityMap, isEmpty);
      },
    );

    test('items getter returns empty list when cart is null', () {
      const state = CartState(cart: null);
      expect(state.items, equals([]));
    });

    test('items getter returns list of items when cart exists', () {
      final state = CartState(cart: tCart);
      expect(state.items, equals([tItem1, tItem2]));
    });

    test('totalQuantity getter returns sum of item quantities from cart', () {
      final state = CartState(cart: tCart);
      expect(state.totalQuantity, equals(5));
    });

    test(
      'productQuantityMap maps productIds to their quantities correctly',
      () {
        final state = CartState(cart: tCart);
        final map = state.productQuantityMap;

        expect(map['prod_1'], equals(2));
        expect(map['prod_2'], equals(3));
        expect(map['prod_unknown'], isNull);
      },
    );

    test(
      'getQuantity returns correct quantity or 0 if item does not exist',
      () {
        final state = CartState(cart: tCart);

        expect(state.getQuantity('prod_1'), equals(2));
        expect(state.getQuantity('prod_2'), equals(3));
        expect(state.getQuantity('prod_unknown'), equals(0));
      },
    );

    test(
      'isProductLoading returns true only for matching loadingProductId',
      () {
        const state = CartState(loadingProductId: 'prod_1');

        expect(state.isProductLoading('prod_1'), isTrue);
        expect(state.isProductLoading('prod_2'), isFalse);
      },
    );

    test('getItemByProductId returns matching item or null if not found', () {
      final state = CartState(cart: tCart);

      expect(state.getItemByProductId('prod_1'), equals(tItem1));
      expect(state.getItemByProductId('non_existing_prod'), isNull);
    });

    test(
      'copyWith updates and clears fields correctly using function getters',
      () {
        const initialState = CartState(errorMessage: 'Old Error');

        final updatedState = initialState.copyWith(
          isLoading: true,
          loadingProductId: () => 'prod_1',
          errorMessage: () => 'Something went wrong',
          cart: tCart,
        );

        expect(updatedState.isLoading, isTrue);
        expect(updatedState.loadingProductId, equals('prod_1'));
        expect(updatedState.errorMessage, equals('Something went wrong'));
        expect(updatedState.cart, equals(tCart));

        // Test explicit clearing to null
        final clearedState = updatedState.copyWith(
          loadingProductId: () => null,
          errorMessage: () => null,
        );

        expect(clearedState.loadingProductId, isNull);
        expect(clearedState.errorMessage, isNull);
      },
    );

    test('props equality holds for identical states', () {
      final stateA = CartState(
        cart: tCart,
        isLoading: false,
        loadingProductId: 'prod_1',
      );
      final stateB = CartState(
        cart: tCart,
        isLoading: false,
        loadingProductId: 'prod_1',
      );

      expect(stateA, equals(stateB));
    });
  });
}

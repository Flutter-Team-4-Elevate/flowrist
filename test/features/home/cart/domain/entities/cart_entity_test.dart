import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

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

  group('CartItemEntity Tests', () {
    test(
      'copyWith should update quantity correctly while preserving other fields',
      () {
        final updatedItem = tItem1.copyWith(quantity: 5);

        expect(updatedItem.quantity, equals(5));
        expect(updatedItem.itemId, equals(tItem1.itemId));
        expect(updatedItem.productId, equals(tItem1.productId));
        expect(updatedItem.unitPrice, equals(tItem1.unitPrice));
        expect(updatedItem.productName, equals(tItem1.productName));
      },
    );

    test('props equality should consider all properties', () {
      const identicalItem = CartItemEntity(
        itemId: 'item_1',
        productId: 'prod_1',
        productName: 'Red Roses',
        productImage: 'roses.png',
        unitPrice: 50,
        priceAtAdd: 50,
        quantity: 2,
        availableStock: 10,
      );

      const itemWithDifferentPrice = CartItemEntity(
        itemId: 'item_1',
        productId: 'prod_1',
        productName: 'Red Roses',
        productImage: 'roses.png',
        unitPrice: 999,
        priceAtAdd: 999,
        quantity: 2,
        availableStock: 10,
      );

      expect(tItem1, equals(identicalItem));
      expect(tItem1, isNot(equals(itemWithDifferentPrice)));
    });
  });

  group('CartEntity Tests', () {
    test('totalQuantity getter should return 0 when items list is empty', () {
      const emptyCart = CartEntity(cartId: 'cart_empty', items: [], total: 0);

      expect(emptyCart.totalQuantity, equals(0));
    });

    test(
      'totalQuantity getter should calculate sum of all item quantities correctly',
      () {
        final cart = CartEntity(
          cartId: 'cart_123',
          items: const [tItem1, tItem2],
          total: 190,
        );

        // 2 + 3 = 5
        expect(cart.totalQuantity, equals(5));
      },
    );

    test('CartEntity instances with same properties should be equal', () {
      final cartA = CartEntity(
        cartId: 'cart_123',
        items: const [tItem1],
        total: 100,
      );
      final cartB = CartEntity(
        cartId: 'cart_123',
        items: const [tItem1],
        total: 100,
      );

      expect(cartA, equals(cartB));
    });
  });
}

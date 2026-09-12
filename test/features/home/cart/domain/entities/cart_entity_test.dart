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
    lineSubtotal: 100,
    availableStock: 10,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  const tItem2 = CartItemEntity(
    itemId: 'item_2',
    productId: 'prod_2',
    productName: 'Tulips',
    productImage: 'tulips.png',
    unitPrice: 30,
    priceAtAdd: 30,
    quantity: 3,
    lineSubtotal: 90,
    availableStock: 5,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
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
        expect(updatedItem.lineSubtotal, equals(tItem1.lineSubtotal));
        expect(updatedItem.availableStock, equals(tItem1.availableStock));
        expect(updatedItem.isAvailable, equals(tItem1.isAvailable));
        expect(updatedItem.priceChanged, equals(tItem1.priceChanged));
        expect(updatedItem.stockChanged, equals(tItem1.stockChanged));
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
        lineSubtotal: 100,
        availableStock: 10,
        isAvailable: true,
        priceChanged: false,
        stockChanged: false,
      );

      const itemWithDifferentPrice = CartItemEntity(
        itemId: 'item_1',
        productId: 'prod_1',
        productName: 'Red Roses',
        productImage: 'roses.png',
        unitPrice: 999,
        priceAtAdd: 999,
        quantity: 2,
        lineSubtotal: 1998,
        availableStock: 10,
        isAvailable: true,
        priceChanged: true,
        stockChanged: false,
      );

      expect(tItem1, equals(identicalItem));
      expect(tItem1, isNot(equals(itemWithDifferentPrice)));
    });
  });

  group('CartEntity Tests', () {
    test('should store totalQuantity correctly', () {
      const emptyCart = CartEntity(
        cartId: 'cart_empty',
        items: [],
        totalQuantity: 0,
        lineCount: 0,
        subtotal: 0,
        deliveryFee: 50,
        total: 50,
        hasChanges: false,
      );

      expect(emptyCart.totalQuantity, equals(0));
    });

    test('should store totalQuantity correctly for multiple items', () {
      const cart = CartEntity(
        cartId: 'cart_123',
        items: [tItem1, tItem2],
        totalQuantity: 5,
        lineCount: 2,
        subtotal: 190,
        deliveryFee: 50,
        total: 240,
        hasChanges: false,
      );

      // 2 + 3 = 5
      expect(cart.totalQuantity, equals(5));
    });

    test('CartEntity instances with same properties should be equal', () {
      const cartA = CartEntity(
        cartId: 'cart_123',
        items: [tItem1],
        totalQuantity: 2,
        lineCount: 1,
        subtotal: 100,
        deliveryFee: 50,
        total: 150,
        hasChanges: false,
      );

      const cartB = CartEntity(
        cartId: 'cart_123',
        items: [tItem1],
        totalQuantity: 2,
        lineCount: 1,
        subtotal: 100,
        deliveryFee: 50,
        total: 150,
        hasChanges: false,
      );

      expect(cartA, equals(cartB));
    });

    test('CartEntity should not be equal when one property is different', () {
      const cartA = CartEntity(
        cartId: 'cart_123',
        items: [tItem1],
        totalQuantity: 2,
        lineCount: 1,
        subtotal: 100,
        deliveryFee: 50,
        total: 150,
        hasChanges: false,
      );

      const cartB = CartEntity(
        cartId: 'cart_123',
        items: [tItem1],
        totalQuantity: 2,
        lineCount: 1,
        subtotal: 100,
        deliveryFee: 50,
        total: 200,
        hasChanges: false,
      );

      expect(cartA, isNot(equals(cartB)));
    });
  });
}

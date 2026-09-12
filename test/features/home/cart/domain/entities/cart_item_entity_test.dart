import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

void main() {
  const tItemA = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    lineSubtotal: 50,
    availableStock: 10,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  const tItemB = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    lineSubtotal: 50,
    availableStock: 10,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  const tItemDifferentPrice = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 70,
    priceAtAdd: 70,
    quantity: 1,
    lineSubtotal: 70,
    availableStock: 10,
    isAvailable: true,
    priceChanged: true,
    stockChanged: false,
  );

  group('CartItemEntity Tests', () {
    test('supports value equality for identical properties', () {
      expect(tItemA, equals(tItemB));
    });

    test('is not equal when unitPrice changes', () {
      expect(tItemA, isNot(equals(tItemDifferentPrice)));
    });

    test('copyWith creates an updated copy with modified quantity', () {
      final updated = tItemA.copyWith(quantity: 3);

      expect(updated.quantity, equals(3));
      expect(updated.itemId, equals(tItemA.itemId));
      expect(updated.productId, equals(tItemA.productId));
      expect(updated.productName, equals(tItemA.productName));
      expect(updated.unitPrice, equals(tItemA.unitPrice));
      expect(updated.lineSubtotal, equals(tItemA.lineSubtotal));
    });

    test('copyWith should update availability correctly', () {
      final updated = tItemA.copyWith(
        isAvailable: false,
      );

      expect(updated.isAvailable, isFalse);
      expect(updated.itemId, equals(tItemA.itemId));
      expect(updated.productId, equals(tItemA.productId));
    });

    test('copyWith should update priceChanged correctly', () {
      final updated = tItemA.copyWith(
        priceChanged: true,
      );

      expect(updated.priceChanged, isTrue);
      expect(updated.unitPrice, equals(tItemA.unitPrice));
    });

    test('copyWith should update stockChanged correctly', () {
      final updated = tItemA.copyWith(
        stockChanged: true,
      );

      expect(updated.stockChanged, isTrue);
      expect(updated.availableStock, equals(tItemA.availableStock));
    });
  });
}

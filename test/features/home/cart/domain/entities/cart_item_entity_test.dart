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
    availableStock: 10,
  );

  const tItemB = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    availableStock: 10,
  );

  const tItemDifferentPrice = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 70, // سعر مختلف
    priceAtAdd: 70,
    quantity: 1,
    availableStock: 10,
  );

  group('CartItemEntity Tests', () {
    test('supports value equality for identical properties', () {
      expect(tItemA, equals(tItemB));
    });

    test('is not equal when unitPrice or other attributes differ', () {
      expect(tItemA, isNot(equals(tItemDifferentPrice)));
    });

    test('copyWith creates an updated copy with modified fields', () {
      final updated = tItemA.copyWith(quantity: 3);
      expect(updated.quantity, equals(3));
      expect(updated.itemId, equals(tItemA.itemId));
    });
  });
}

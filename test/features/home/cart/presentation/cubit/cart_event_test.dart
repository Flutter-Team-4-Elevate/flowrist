import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';

void main() {
  group('CartEvent Unit Tests', () {
    test('GetCartEvent can be instantiated correctly', () {
      final event = GetCartEvent();
      expect(event, isA<CartEvent>());
    });

    test('AddToCartEvent holds correct productId', () {
      final event = AddToCartEvent(productId: 'prod_1');

      expect(event, isA<CartEvent>());
      expect(event.productId, equals('prod_1'));
    });

    test('ChangeCartQuantityEvent holds correct productId and delta', () {
      final event = ChangeCartQuantityEvent(productId: 'prod_1', delta: 1);

      expect(event, isA<CartEvent>());
      expect(event.productId, equals('prod_1'));
      expect(event.delta, equals(1));
    });

    test('RemoveCartItemEvent holds correct itemId', () {
      final event = RemoveCartItemEvent(itemId: 'item_1');

      expect(event, isA<CartEvent>());
      expect(event.itemId, equals('item_1'));
    });
  });
}

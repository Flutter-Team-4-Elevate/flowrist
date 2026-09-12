import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';

void main() {
  group('UpdateCartItemRequestDto Unit Tests', () {
    test('toJson should convert object properties to valid Map', () {
      const dto = UpdateCartItemRequestDto(quantity: 8);

      final json = dto.toJson();

      expect(json, equals({'quantity': 8}));
    });
  });
}

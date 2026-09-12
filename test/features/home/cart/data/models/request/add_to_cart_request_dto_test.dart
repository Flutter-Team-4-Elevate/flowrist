import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';

void main() {
  group('AddToCartRequestDto Unit Tests', () {
    test('toJson should convert object properties to valid Map', () {
      const dto = AddToCartRequestDto(productId: 'prod_999', quantity: 5);

      final json = dto.toJson();

      expect(json, equals({'productId': 'prod_999', 'quantity': 5}));
    });
  });
}

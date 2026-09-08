import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/data/mapper/cart_mapper.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';

void main() {
  group('CartMapper Tests', () {
    test('maps valid CartResponseDto to CartEntity correctly', () {
      final dto = CartResponseDto(
        data: CartDataDto(
          cartId: 'cart_123',
          total: 100,
          items: [
            CartItemDto(
              itemId: 'item_1',
              productId: 'prod_1',
              productName: 'Roses',
              productImage: 'img.png',
              unitPrice: 50,
              priceAtAdd: 50,
              quantity: 2,
              availableStock: 10,
            ),
          ],
        ),
      );

      final entity = CartMapper.toCartEntity(dto);

      expect(entity.cartId, equals('cart_123'));
      expect(entity.total, equals(100));
      expect(entity.items.length, equals(1));
      expect(entity.items.first.itemId, equals('item_1'));
    });

    test('filters out items with missing or empty itemId / productId', () {
      final dto = CartResponseDto(
        data: CartDataDto(
          cartId: 'cart_123',
          total: 50,
          items: [
            CartItemDto(
              itemId: null, // عنصر تالف
              productId: 'prod_1',
            ),
            CartItemDto(
              itemId: 'item_2',
              productId: '', // عنصر ناقص
            ),
            CartItemDto(
              itemId: 'item_3',
              productId: 'prod_3',
              unitPrice: 50,
              quantity: 1,
            ),
          ],
        ),
      );

      final entity = CartMapper.toCartEntity(dto);

      expect(entity.items.length, equals(1));
      expect(entity.items.first.itemId, equals('item_3'));
    });
  });
}

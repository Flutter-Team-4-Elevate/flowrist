import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';

void main() {
  group('CartResponseDto Serialization Tests', () {
    final Map<String, dynamic> tJson = {
      'status': true,
      'code': 200,
      'message': 'Cart retrieved successfully',
      'data': {
        'cartId': 'cart_123',
        'totalQuantity': 2,
        'lineCount': 1,
        'subtotal': 100,
        'total': 100,
        'items': [
          {
            'itemId': 'item_1',
            'productId': 'prod_1',
            'productName': 'Red Rose',
            'productImage': 'rose.png',
            'unitPrice': 50,
            'priceAtAdd': 50,
            'quantity': 2,
            'lineSubtotal': 100,
            'availableStock': 10,
            'isAvailable': true,
          },
        ],
      },
    };

    test(
      'fromJson should parse complete json correctly into CartResponseDto',
      () {
        final dto = CartResponseDto.fromJson(tJson);

        expect(dto.status, isTrue);
        expect(dto.code, equals(200));
        expect(dto.message, equals('Cart retrieved successfully'));
        expect(dto.data?.cartId, equals('cart_123'));
        expect(dto.data?.totalQuantity, equals(2));
        expect(dto.data?.items?.length, equals(1));

        final item = dto.data?.items?.first;
        expect(item?.itemId, equals('item_1'));
        expect(item?.productId, equals('prod_1'));
        expect(item?.productName, equals('Red Rose'));
        expect(item?.unitPrice, equals(50));
        expect(item?.quantity, equals(2));
        expect(item?.isAvailable, isTrue);
      },
    );

    test('toJson should convert CartResponseDto fields correctly', () {
      final dto = CartResponseDto.fromJson(tJson);
      final jsonResult = dto.toJson();

      expect(jsonResult['status'], equals(true));
      expect(jsonResult['code'], equals(200));
      expect(jsonResult['message'], equals('Cart retrieved successfully'));

      // التحقق من الحقل سواء كان Map أو كائن CartDataDto
      final dataField = jsonResult['data'];
      if (dataField is Map) {
        expect(dataField['cartId'], equals('cart_123'));
      } else if (dataField is CartDataDto) {
        expect(dataField.cartId, equals('cart_123'));
      }
    });

    test('fromJson should handle empty json map safely', () {
      final dto = CartResponseDto.fromJson({});

      expect(dto.status, isNull);
      expect(dto.code, isNull);
      expect(dto.message, isNull);
      expect(dto.data, isNull);
    });
  });
}

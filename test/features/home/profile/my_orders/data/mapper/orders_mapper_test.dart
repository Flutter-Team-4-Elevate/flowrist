import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/profile/my_orders/data/mapper/orders_mapper.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';

void main() {
  group('OrdersMapper.toOrderEntityList', () {
    test(
      'should map OrdersResponseDto to List<OrderEntity> correctly and filter empty IDs',
      () {
        const dto = OrdersResponseDto(
          data: [
            OrderItemDto(
              id: '1',
              orderNumber: 'ORD-1',
              status: 'Delivered',
              total: 250,
              itemCount: 2,
              createdAt: '2026-09-01T10:00:00.000Z',
            ),
            OrderItemDto(
              id: '2',
              orderNumber: 'ORD-2',
              status: 'Pending',
              total: 150,
              itemCount: 1,
            ),
            OrderItemDto(id: '', orderNumber: 'ORD-INVALID'),
          ],
        );

        final result = OrdersMapper.toOrderEntityList(dto);

        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].displayStatus, OrderDisplayStatus.completed);
        expect(result[0].total, 250.0);
        expect(result[1].id, '2');
        expect(result[1].displayStatus, OrderDisplayStatus.active);
      },
    );

    test('should return empty list when data is null', () {
      const dto = OrdersResponseDto(data: null);
      final result = OrdersMapper.toOrderEntityList(dto);
      expect(result, isEmpty);
    });
  });

  group('OrdersMapper.toOrderDetailsEntity', () {
    test(
      'should map OrderDetailsResponseDto to OrderDetailsEntity correctly',
      () {
        const dto = OrderDetailsResponseDto(
          data: OrderDetailsDataDto(
            id: '10',
            orderNumber: 'ORD-999',
            status: 'Confirmed',
            paymentMethod: 'CreditCard',
            paymentStatus: 'Paid',
            subtotal: 300,
            deliveryFee: 50,
            total: 350,
            createdAt: '2026-09-01T10:00:00.000Z',
          ),
        );

        final result = OrdersMapper.toOrderDetailsEntity(dto);

        expect(result.id, '10');
        expect(result.orderNumber, 'ORD-999');
        expect(result.subtotal, 300.0);
        expect(result.deliveryFee, 50.0);
        expect(result.total, 350.0);
        expect(result.status, 'Confirmed');
      },
    );

    test('should handle null data gracefully', () {
      const dto = OrderDetailsResponseDto(data: null);
      final result = OrdersMapper.toOrderDetailsEntity(dto);

      expect(result.id, '');
      expect(result.orderNumber, '');
      expect(result.total, 0.0);
    });
  });
}

import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';

abstract final class OrdersMapper {
  static List<OrderEntity> toOrderEntityList(OrdersResponseDto dto) {
    final items = dto.data ?? [];
    return items.where((item) => item.id != null && item.id!.isNotEmpty).map((
      item,
    ) {
      final isDelivered = (item.status ?? '').toLowerCase() == 'delivered';
      return OrderEntity(
        id: item.id!,
        orderNumber: item.orderNumber ?? '',
        createdAt: item.createdAt != null
            ? DateTime.tryParse(item.createdAt!)
            : null,
        itemCount: item.itemCount ?? 1,
        firstItemThumbnailUrl: item.firstItemThumbnailUrl,
        rawStatus: item.status ?? '',
        displayStatus: isDelivered
            ? OrderDisplayStatus.completed
            : OrderDisplayStatus.active,
        total: (item.total ?? 0).toDouble(),
        paymentStatus: item.paymentStatus ?? '',
      );
    }).toList();
  }

  static OrderDetailsEntity toOrderDetailsEntity(OrderDetailsResponseDto dto) {
    final data = dto.data;
    return OrderDetailsEntity(
      id: data?.id ?? '',
      orderNumber: data?.orderNumber ?? '',
      status: data?.status ?? '',
      paymentMethod: data?.paymentMethod ?? '',
      paymentStatus: data?.paymentStatus ?? '',
      subtotal: (data?.subtotal ?? 0).toDouble(),
      deliveryFee: (data?.deliveryFee ?? 0).toDouble(),
      total: (data?.total ?? 0).toDouble(),
      createdAt: data?.createdAt != null
          ? DateTime.tryParse(data!.createdAt!)
          : null,
    );
  }
}

import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';

class PaginatedOrdersEntity {
  final List<OrderEntity> orders;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const PaginatedOrdersEntity({
    required this.orders,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}

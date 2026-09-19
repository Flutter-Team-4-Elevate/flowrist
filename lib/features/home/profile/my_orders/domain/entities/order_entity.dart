import 'package:equatable/equatable.dart';

enum OrderDisplayStatus { active, completed }

class OrderEntity extends Equatable {
  final String id;
  final String orderNumber;
  final DateTime? createdAt;
  final int itemCount;
  final String? firstItemThumbnailUrl;
  final String rawStatus;
  final OrderDisplayStatus displayStatus;
  final double total;
  final String paymentStatus;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    this.createdAt,
    required this.itemCount,
    this.firstItemThumbnailUrl,
    required this.rawStatus,
    required this.displayStatus,
    required this.total,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    createdAt,
    itemCount,
    firstItemThumbnailUrl,
    rawStatus,
    displayStatus,
    total,
    paymentStatus,
  ];
}

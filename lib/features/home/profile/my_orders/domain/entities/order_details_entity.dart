import 'package:equatable/equatable.dart';

class OrderDetailsEntity extends Equatable {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime? createdAt;

  const OrderDetailsEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    paymentMethod,
    paymentStatus,
    subtotal,
    deliveryFee,
    total,
    createdAt,
  ];
}

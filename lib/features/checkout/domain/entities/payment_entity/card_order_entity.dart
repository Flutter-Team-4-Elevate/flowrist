import 'package:equatable/equatable.dart';

class CardOrderEntity extends Equatable {
  // Common fields
  final String orderId;
  final String status;

  // COD fields
  final String? orderNumber;
  final String? paymentStatus;
  final String? paymentMethod;
  final double? subtotal;
  final double? deliveryFee;
  final double? total;

  // Card fields
  final String? gateway;
  final String? sessionId;
  final String? sessionUrl;
  final String? successUrl;
  final String? cancelUrl;
  final DateTime? expiresAt;
  final double? amount;
  final String? currency;
  final DateTime? estimatedDeliveryAt;

  const CardOrderEntity({
    required this.orderId,
    required this.status,

    this.orderNumber,
    this.paymentStatus,
    this.paymentMethod,
    this.subtotal,
    this.deliveryFee,
    this.total,

    this.gateway,
    this.sessionId,
    this.sessionUrl,
    this.successUrl,
    this.cancelUrl,
    this.expiresAt,
    this.amount,
    this.currency,
    this.estimatedDeliveryAt,
  });

  bool get isCashOrder => paymentMethod == 'COD';

  bool get isCardOrder => paymentMethod == 'Card';

  @override
  List<Object?> get props => [
    orderId,
    status,
    orderNumber,
    paymentStatus,
    paymentMethod,
    subtotal,
    deliveryFee,
    total,
    gateway,
    sessionId,
    sessionUrl,
    successUrl,
    cancelUrl,
    expiresAt,
    amount,
    currency,
    estimatedDeliveryAt,
  ];
}

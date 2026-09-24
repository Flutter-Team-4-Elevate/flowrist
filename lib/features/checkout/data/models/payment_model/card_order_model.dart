import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_order_model.g.dart';

@JsonSerializable()
class CardOrderModel {
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

  const CardOrderModel({
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

  factory CardOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CardOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardOrderModelToJson(this);

  CardOrderEntity toEntity() {
    return CardOrderEntity(
      orderId: orderId,
      status: status,

      orderNumber: orderNumber,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,

      gateway: gateway,
      sessionId: sessionId,
      sessionUrl: sessionUrl,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
      expiresAt: expiresAt,
      amount: amount,
      currency: currency,
      estimatedDeliveryAt: estimatedDeliveryAt,
    );
  }
}

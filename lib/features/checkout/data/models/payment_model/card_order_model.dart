import 'package:json_annotation/json_annotation.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';

part 'card_order_model.g.dart';

@JsonSerializable()
class CardOrderModel {
  final String orderId;
  final String status;
  final String gateway;
  final String sessionId;
  final String sessionUrl;
  final String successUrl;
  final String cancelUrl;
  final DateTime expiresAt;
  final double amount;
  final String currency;
  final DateTime? estimatedDeliveryAt;

  const CardOrderModel({
    required this.orderId,
    required this.status,
    required this.gateway,
    required this.sessionId,
    required this.sessionUrl,
    required this.successUrl,
    required this.cancelUrl,
    required this.expiresAt,
    required this.amount,
    required this.currency,
    this.estimatedDeliveryAt,
  });

  factory CardOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CardOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardOrderModelToJson(this);

  CardOrderEntity toEntity() {
    return CardOrderEntity(
      orderId: orderId,
      status: status,
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
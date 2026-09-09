import 'package:json_annotation/json_annotation.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';

part 'delivery_fee_model.g.dart';

@JsonSerializable()
class DeliveryFeeModel {
  final String addressId;
  final bool isServiceable;
  final double deliveryFee;
  final DateTime? estimatedDeliveryAt;

  const DeliveryFeeModel({
    required this.addressId,
    required this.isServiceable,
    required this.deliveryFee,
    this.estimatedDeliveryAt,
  });

  factory DeliveryFeeModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryFeeModelToJson(this);

  DeliveryFeeEntity toEntity() {
    return DeliveryFeeEntity(
      addressId: addressId,
      isServiceable: isServiceable,
      deliveryFee: deliveryFee,
      estimatedDeliveryAt: estimatedDeliveryAt,
    );
  }
}
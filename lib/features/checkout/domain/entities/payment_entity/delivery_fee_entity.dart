import 'package:equatable/equatable.dart';

class DeliveryFeeEntity extends Equatable {
  final String addressId;
  final bool isServiceable;
  final double deliveryFee;
  final DateTime? estimatedDeliveryAt;

  const DeliveryFeeEntity({
    required this.addressId,
    required this.isServiceable,
    required this.deliveryFee,
    this.estimatedDeliveryAt,
  });

  @override
  List<Object?> get props => [
        addressId,
        isServiceable,
        deliveryFee,
        estimatedDeliveryAt,
      ];
}
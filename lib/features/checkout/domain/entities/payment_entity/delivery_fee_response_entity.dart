import 'package:equatable/equatable.dart';
import 'delivery_fee_entity.dart';

class DeliveryFeeResponseEntity extends Equatable {
  final bool status;
  final int code;
  final String message;
  final DeliveryFeeEntity? data;

  const DeliveryFeeResponseEntity({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [
        status,
        code,
        message,
        data,
      ];
}
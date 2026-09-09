import 'package:equatable/equatable.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';

class CardOrderResponseEntity extends Equatable {
  final bool status;
  final int code;
  final String message;
  final CardOrderEntity? data;

  const CardOrderResponseEntity({
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
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';

abstract class CheckoutRepository {
  Future<BaseResponse<CardOrderEntity?>> placeOrder(
    CardOrderRequestEntity request,
  );

  Future<BaseResponse<DeliveryFeeEntity>> getDeliveryFee({
    required String addressId,
    required String cartId,
  });
}
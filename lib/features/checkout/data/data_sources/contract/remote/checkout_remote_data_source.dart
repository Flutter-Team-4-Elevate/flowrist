import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_response_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<BaseResponse<CardOrderResponseModel>> placeOrder(
    CardOrderRequestModel request,
  );

  Future<BaseResponse<DeliveryFeeModel>> getDeliveryFee({
    required String addressId,
    required String cartId,
  });
}
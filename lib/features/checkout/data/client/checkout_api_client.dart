import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_response_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'checkout_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class CheckoutApiClient {
  @factoryMethod
  factory CheckoutApiClient(Dio dio) = _CheckoutApiClient;

  @POST(Endpoints.placeOrder)
  Future<CardOrderResponseModel> placeOrder(
    @Body() Map<String, dynamic> request,
    @Header(Endpoints.idempotencyKey) String idempotencyKey,
  );

  @GET(Endpoints.deliveryFee)
  Future<DeliveryFeeResponseModel> getDeliveryFee({
    @Query(Endpoints.addressId) required String addressId,
    @Query(Endpoints.cartId) required String cartId,
  });
}

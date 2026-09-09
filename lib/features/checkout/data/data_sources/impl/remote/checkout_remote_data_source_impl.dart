import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/client/checkout_api_client.dart';
import 'package:flowrist/features/checkout/data/data_sources/contract/remote/checkout_remote_data_source.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_response_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_model.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: CheckoutRemoteDataSource)
class CheckoutRemoteDataSourceImpl
    implements CheckoutRemoteDataSource {
  final CheckoutApiClient _apiClient;

  CheckoutRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<CardOrderResponseModel>> placeOrder(
    CardOrderRequestModel request,
  ) async {
    try {
      final idempotencyKey = const Uuid().v4();

      final response = await _apiClient.placeOrder(
        request.toJson(),
        idempotencyKey,
      );

      return SuccessResponse<CardOrderResponseModel>(
        response,
      );
    } on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }

  @override
  Future<BaseResponse<DeliveryFeeModel>> getDeliveryFee({
    required String addressId,
    required String cartId,
  }) async {
    try {
      final response = await _apiClient.getDeliveryFee(
        addressId: addressId,
        cartId: cartId,
      );

      final deliveryFee = response.data;

      if (deliveryFee == null) {
        return ErrorResponse<DeliveryFeeModel>(
          response.message,
        );
      }

      return SuccessResponse<DeliveryFeeModel>(
        deliveryFee,
      );
    } on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }
}
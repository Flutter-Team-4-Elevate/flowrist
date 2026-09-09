import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/data_sources/contract/remote/checkout_remote_data_source.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_response_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_model.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CheckoutRepository)
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource _remoteDataSource;

  CheckoutRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<CardOrderEntity?>> placeOrder(
    CardOrderRequestEntity order,
  ) async {
    final request = CardOrderRequestModel.fromEntity(order);

    final response = await _remoteDataSource.placeOrder(request);

    switch (response) {
      case SuccessResponse<CardOrderResponseModel>():
        final responseEntity = response.data!.toEntity();
        return SuccessResponse<CardOrderEntity?>(
          responseEntity.data,
        );

      case ErrorResponse<CardOrderResponseModel>():
        return ErrorResponse<CardOrderEntity?>(
          response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<DeliveryFeeEntity>> getDeliveryFee({
    required String addressId,
    required String cartId,
  }) async {
    final response = await _remoteDataSource.getDeliveryFee(
      addressId: addressId,
      cartId: cartId,
    );

    switch (response) {
      case SuccessResponse<DeliveryFeeModel>():
        final model = response.data;

        if (model == null) {
          return ErrorResponse<DeliveryFeeEntity>(
            'Invalid delivery fee response',
          );
        }

        return SuccessResponse<DeliveryFeeEntity>(
          model.toEntity(),
        );

      case ErrorResponse<DeliveryFeeModel>():
        return ErrorResponse<DeliveryFeeEntity>(
          response.errorMessage,
        );
    }
  }
}
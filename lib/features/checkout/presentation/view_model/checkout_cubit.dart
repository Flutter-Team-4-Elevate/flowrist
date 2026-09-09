import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/use_cases/get_delivery_fee_use_case.dart';
import 'package:flowrist/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/addresses/domain/entities/address_entity.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetDeliveryFeeUseCase _getDeliveryFeeUseCase;
  final GetAllUserAddressesUseCase _getAllUserAddressesUseCase;

  CheckoutCubit(
    this._placeOrderUseCase,
    this._getDeliveryFeeUseCase,
    this._getAllUserAddressesUseCase,
  ) : super(CheckoutState.initial());

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case SelectPaymentMethod():
        _selectPaymentMethod(event.paymentMethod);

      case PlaceOrder():
        _placeOrder(event.order);

      case GetDeliveryFee():
        _getDeliveryFee(
          addressId: event.addressId,
          cartId: event.cartId,
        );

      case UpdateGiftInfo():
        _updateGiftInfo(
          isGift: event.isGift,
          name: event.name,
          phone: event.phone,
        );

      case GetAddressesEvent():
        _getAddresses();

      case SelectDeliveryAddressEvent():
        _selectAddress(event.addressId);
    }
  }

  void _selectPaymentMethod(String paymentMethod) {
    final isCashOnDelivery = paymentMethod == Endpoints.cash;

    emit(
      state.copyWith(
        selectedPaymentMethod: paymentMethod,

        // Cash on Delivery does not support gifts.
        isGift: isCashOnDelivery ? false : state.isGift,

        // Clear gift information when switching to Cash.
        giftName: isCashOnDelivery ? '' : state.giftName,
        giftPhone: isCashOnDelivery ? '' : state.giftPhone,

        // Reset previous order state.
        placeOrderState: BaseState<CardOrderEntity?>.initial(),
      ),
    );
  }

  void _selectAddress(String addressId) {
    emit(
      state.copyWith(
        selectedAddressId: addressId,
      ),
    );
  }

  void _updateGiftInfo({
    required bool isGift,
    required String name,
    required String phone,
  }) {
    emit(
      state.copyWith(
        isGift: isGift,
        giftName: isGift ? name : '',
        giftPhone: isGift ? phone : '',
      ),
    );
  }

  Future<void> _placeOrder(
    CardOrderRequestEntity order,
  ) async {
    emit(
      state.copyWith(
        placeOrderState:
            BaseState<CardOrderEntity?>.loading(),
      ),
    );

    try {
      final response = await _placeOrderUseCase(order);

      switch (response) {
        case SuccessResponse<CardOrderEntity?>():
          final entity = response.data;

          emit(
            state.copyWith(
              placeOrderState:
                  BaseState<CardOrderEntity?>.success(entity),
            ),
          );

        case ErrorResponse<CardOrderEntity?>():
          emit(
            state.copyWith(
              placeOrderState:
                  BaseState<CardOrderEntity?>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          placeOrderState:
              BaseState<CardOrderEntity?>.error(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _getDeliveryFee({
    required String addressId,
    required String cartId,
  }) async {
    emit(
      state.copyWith(
        deliveryFeeState:
            BaseState<DeliveryFeeEntity>.loading(),
      ),
    );

    try {
      final response = await _getDeliveryFeeUseCase(
        addressId: addressId,
        cartId: cartId,
      );

      switch (response) {
        case SuccessResponse<DeliveryFeeEntity>():
          final entity = response.data;

          if (entity == null) {
            emit(
              state.copyWith(
                deliveryFeeState:
                    BaseState<DeliveryFeeEntity>.error(
                  'Invalid delivery fee response',
                ),
              ),
            );
            return;
          }

          emit(
            state.copyWith(
              deliveryFeeState:
                  BaseState<DeliveryFeeEntity>.success(
                entity,
              ),
            ),
          );

        case ErrorResponse<DeliveryFeeEntity>():
          emit(
            state.copyWith(
              deliveryFeeState:
                  BaseState<DeliveryFeeEntity>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          deliveryFeeState:
              BaseState<DeliveryFeeEntity>.error(
            e.toString(),
          ),
        ),
      );
    }
  }

  void reset() {
    emit(
      CheckoutState.initial(),
    );
  }

  Future<void> _getAddresses() async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final response = await _getAllUserAddressesUseCase();

      switch (response) {
        case SuccessResponse<List<AddressEntity>>():
          final addresses = response.data ?? const [];

          String? selectedId =
              state.selectedAddressId;

          if (selectedId == null && addresses.isNotEmpty) {
            final defaultAddress = addresses.firstWhere(
              (a) => a.isDefault,
              orElse: () => addresses.first,
            );

            selectedId = defaultAddress.id;
          }

          emit(
            state.copyWith(
              addressesState:
                  BaseState<List<AddressEntity>>.success(
                addresses,
              ),
              selectedAddressId: selectedId,
            ),
          );

        case ErrorResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState:
                  BaseState<List<AddressEntity>>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          addressesState:
              BaseState<List<AddressEntity>>.error(
            e.toString(),
          ),
        ),
      );
    }
  }
}
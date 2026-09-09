import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';

import '../../../../shared/addresses/domain/entities/address_entity.dart';

class CheckoutState extends Equatable {
  final BaseState<CardOrderEntity?> placeOrderState;
  final BaseState<DeliveryFeeEntity> deliveryFeeState;
  final BaseState<List<AddressEntity>> addressesState;

  final String? selectedPaymentMethod;
  final String? selectedAddressId;

  final bool isGift;
  final String giftName;
  final String giftPhone;

  const CheckoutState({
    required this.placeOrderState,
    required this.deliveryFeeState,
    required this.addressesState,
    required this.selectedPaymentMethod,
    required this.selectedAddressId,
    required this.isGift,
    required this.giftName,
    required this.giftPhone,
  });

  factory CheckoutState.initial() {
    return const CheckoutState(
      placeOrderState: BaseState.initial(),
      deliveryFeeState: BaseState.initial(),
      addressesState: BaseState.initial(),
      selectedPaymentMethod: null,
      selectedAddressId: null,
      isGift: false,
      giftName: '',
      giftPhone: '',
    );
  }

  CheckoutState copyWith({
    BaseState<CardOrderEntity?>? placeOrderState,
    BaseState<DeliveryFeeEntity>? deliveryFeeState,
    BaseState<List<AddressEntity>>? addressesState,
    String? selectedPaymentMethod,
    String? selectedAddressId,
    bool? isGift,
    String? giftName,
    String? giftPhone,
  }) {
    return CheckoutState(
      placeOrderState: placeOrderState ?? this.placeOrderState,
      deliveryFeeState: deliveryFeeState ?? this.deliveryFeeState,
      addressesState: addressesState ?? this.addressesState,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      isGift: isGift ?? this.isGift,
      giftName: giftName ?? this.giftName,
      giftPhone: giftPhone ?? this.giftPhone,
    );
  }

  @override
  List<Object?> get props => [
    placeOrderState,
    deliveryFeeState,
    addressesState,
    selectedPaymentMethod,
    selectedAddressId,
    isGift,
    giftName,
    giftPhone,
  ];
}

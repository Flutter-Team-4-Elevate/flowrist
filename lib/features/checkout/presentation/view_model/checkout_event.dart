import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';

sealed class CheckoutEvent {}

class SelectPaymentMethod extends CheckoutEvent {
  final String paymentMethod;

  SelectPaymentMethod({required this.paymentMethod});
}

class PlaceOrder extends CheckoutEvent {
  final CardOrderRequestEntity order;

  PlaceOrder({required this.order});
}

class GetDeliveryFee extends CheckoutEvent {
  final String addressId;
  final String cartId;

  GetDeliveryFee({required this.addressId, required this.cartId});
}

class UpdateGiftInfo extends CheckoutEvent {
  final bool isGift;
  final String name;
  final String phone;

  UpdateGiftInfo({
    required this.isGift,
    required this.name,
    required this.phone,
  });
}

class GetAddressesEvent extends CheckoutEvent {}

class SelectDeliveryAddressEvent extends CheckoutEvent {
  final String addressId;

  SelectDeliveryAddressEvent(this.addressId);
}

import 'package:equatable/equatable.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/gift_recipient_entity.dart';

class CardOrderRequestEntity extends Equatable {
  final String cartId;
  final String addressId;
  final bool isGift;
  final GiftRecipientEntity? giftRecipient;
  final String paymentMethod;
  final String? paymentGateway;

  const CardOrderRequestEntity({
    required this.cartId,
    required this.addressId,
    required this.isGift,
    this.giftRecipient,
    required this.paymentMethod,
    this.paymentGateway,
  });

  @override
  List<Object?> get props => [
        cartId,
        addressId,
        isGift,
        giftRecipient,
        paymentMethod,
        paymentGateway,
      ];
}
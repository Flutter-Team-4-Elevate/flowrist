import 'package:flowrist/features/checkout/data/models/payment_model/gift_recipient_model.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_order_request_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class CardOrderRequestModel {
  final String cartId;
  final String addressId;
  final bool isGift;
  final GiftRecipientModel? giftRecipient;
  final String paymentMethod;
  final String? paymentGateway;

  const CardOrderRequestModel({
    required this.cartId,
    required this.addressId,
    required this.isGift,
    this.giftRecipient,
    required this.paymentMethod,
    this.paymentGateway,
  });

  factory CardOrderRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CardOrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CardOrderRequestModelToJson(this);

  factory CardOrderRequestModel.fromEntity(
    CardOrderRequestEntity entity,
  ) {
    return CardOrderRequestModel(
      cartId: entity.cartId,
      addressId: entity.addressId,
      isGift: entity.isGift,
      giftRecipient: entity.giftRecipient == null
          ? null
          : GiftRecipientModel.fromEntity(
              entity.giftRecipient!,
            ),
      paymentMethod: entity.paymentMethod,
      paymentGateway: entity.paymentGateway,
    );
  }
}
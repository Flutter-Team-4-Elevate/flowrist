import 'package:flowrist/features/checkout/domain/entities/payment_entity/gift_recipient_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gift_recipient_model.g.dart';

@JsonSerializable()
class GiftRecipientModel {
  final String recipientName;
  final String recipientPhone;

  const GiftRecipientModel({
    required this.recipientName,
    required this.recipientPhone,
  });

  factory GiftRecipientModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$GiftRecipientModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GiftRecipientModelToJson(this);

  factory GiftRecipientModel.fromEntity(
    GiftRecipientEntity entity,
  ) {
    return GiftRecipientModel(
      recipientName: entity.recipientName,
      recipientPhone: entity.recipientPhone,
    );
  }
}
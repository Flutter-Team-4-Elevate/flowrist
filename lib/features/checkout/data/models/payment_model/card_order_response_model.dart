import 'package:flowrist/features/checkout/data/models/payment_model/card_order_model.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_order_response_model.g.dart';

@JsonSerializable()
class CardOrderResponseModel {
  final bool status;
  final int code;
  final String message;
  final CardOrderModel? data;
  final dynamic pagination;
  final dynamic errors;

  const CardOrderResponseModel({
    required this.status,
    required this.code,
    required this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory CardOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CardOrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardOrderResponseModelToJson(this);

  CardOrderResponseEntity toEntity() {
    return CardOrderResponseEntity(
      status: status,
      code: code,
      message: message,
      data: data?.toEntity(),
    );
  }
}
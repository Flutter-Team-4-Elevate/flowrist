import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_model.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_fee_response_model.g.dart';

@JsonSerializable()
class DeliveryFeeResponseModel {
  final bool status;
  final int code;
  final String message;
  final DeliveryFeeModel? data;
  final dynamic pagination;
  final dynamic errors;

  const DeliveryFeeResponseModel({
    required this.status,
    required this.code,
    required this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory DeliveryFeeResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DeliveryFeeResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DeliveryFeeResponseModelToJson(this);

  DeliveryFeeResponseEntity toEntity() {
    return DeliveryFeeResponseEntity(
      status: status,
      code: code,
      message: message,
      data: data?.toEntity(),
    );
  }
}
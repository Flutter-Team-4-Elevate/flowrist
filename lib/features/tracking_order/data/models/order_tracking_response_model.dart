import 'package:json_annotation/json_annotation.dart';

import 'order_tracking_model.dart';

part 'order_tracking_response_model.g.dart';

@JsonSerializable()
class OrderTrackingResponseModel {
  final bool status;
  final int code;
  final String message;
  final OrderTrackingModel? data;

  const OrderTrackingResponseModel({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory OrderTrackingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTrackingResponseModelToJson(this);
}

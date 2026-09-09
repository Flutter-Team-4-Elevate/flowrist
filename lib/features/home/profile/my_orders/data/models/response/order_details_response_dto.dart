import 'package:json_annotation/json_annotation.dart';

part 'order_details_response_dto.g.dart';

@JsonSerializable()
class OrderDetailsResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final OrderDetailsDataDto? data;
  final dynamic pagination;
  final dynamic errors;

  const OrderDetailsResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory OrderDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsResponseDtoToJson(this);
}

@JsonSerializable()
class OrderDetailsDataDto {
  final String? id;
  final String? orderNumber;
  final String? status;
  final String? paymentMethod;
  final String? paymentStatus;
  final num? subtotal;
  final num? deliveryFee;
  final num? total;
  final String? createdAt;

  const OrderDetailsDataDto({
    this.id,
    this.orderNumber,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.createdAt,
  });

  factory OrderDetailsDataDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsDataDtoToJson(this);
}

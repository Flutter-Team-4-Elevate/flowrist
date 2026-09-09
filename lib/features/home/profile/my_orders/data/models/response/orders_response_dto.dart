import 'package:json_annotation/json_annotation.dart';

part 'orders_response_dto.g.dart';

@JsonSerializable()
class OrdersResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<OrderItemDto>? data;
  final OrdersPaginationDto? pagination;
  final dynamic errors;

  const OrdersResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory OrdersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseDtoToJson(this);
}

@JsonSerializable()
class OrderItemDto {
  final String? id;
  final String? orderNumber;
  final String? createdAt;
  final int? itemCount;
  final String? firstItemThumbnailUrl;
  final String? status;
  final num? total;
  final String? paymentStatus;

  const OrderItemDto({
    this.id,
    this.orderNumber,
    this.createdAt,
    this.itemCount,
    this.firstItemThumbnailUrl,
    this.status,
    this.total,
    this.paymentStatus,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);
}

@JsonSerializable()
class OrdersPaginationDto {
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  const OrdersPaginationDto({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory OrdersPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$OrdersPaginationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersPaginationDtoToJson(this);
}

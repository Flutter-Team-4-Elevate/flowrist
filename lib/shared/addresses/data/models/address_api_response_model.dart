import 'package:json_annotation/json_annotation.dart';
import 'address_model.dart';

part 'address_api_response_model.g.dart';

@JsonSerializable()
class AddressApiResponseModel {
  final bool status;
  final int code;
  final String message;
  final List<AddressModel>? data;
  final dynamic pagination;
  final dynamic errors;

  AddressApiResponseModel({
    required this.status,
    required this.code,
    required this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory AddressApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AddressApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AddressApiResponseModelToJson(this);
}
import 'package:flowrist/shared/addresses/data/models/default_address_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_default_address_response_model.g.dart';

@JsonSerializable()
class SetDefaultAddressResponseModel {
  final bool status;
  final int code;
  final String message;
  final DefaultAddressResponseModel? data;

  SetDefaultAddressResponseModel({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory SetDefaultAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SetDefaultAddressResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SetDefaultAddressResponseModelToJson(this);
}

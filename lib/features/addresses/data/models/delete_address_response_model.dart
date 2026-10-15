import 'package:json_annotation/json_annotation.dart';

part 'delete_address_response_model.g.dart';

@JsonSerializable()
class DeleteAddressResponseModel {
  final bool status;
  final int code;
  final String message;

  DeleteAddressResponseModel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory DeleteAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteAddressResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAddressResponseModelToJson(this);
}

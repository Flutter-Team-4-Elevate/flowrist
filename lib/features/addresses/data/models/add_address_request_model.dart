import 'package:json_annotation/json_annotation.dart';

part 'add_address_request_model.g.dart';

@JsonSerializable()
class AddAddressRequestModel {
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final int governorateId;
  final int cityId;
  final String area;
  final double lat;
  final double lng;
  final String label;

  AddAddressRequestModel({
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.governorateId,
    required this.cityId,
    required this.area,
    required this.lat,
    required this.lng,
    required this.label,
  });

  factory AddAddressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddAddressRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressRequestModelToJson(this);
}

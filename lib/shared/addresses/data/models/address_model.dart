import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;

  final String recipientName;

  final String recipientPhone;

  final String addressLine;

  @JsonKey(name: 'cityName')
  final String city;

  final String area;

  final String? label;

  final double lat;

  final double lng;

  final bool isDefault;

  final String? storeId;

  final bool isServiceable;

  final DateTime createdAt;

  final DateTime updatedAt;

  const AddressModel({
    required this.id,
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.city,
    required this.area,
    this.label,
    required this.lat,
    required this.lng,
    required this.isDefault,
    this.storeId,
    required this.isServiceable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AddressModelToJson(this);

  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      addressLine: addressLine,
      city: city,
      area: area,
      label: label,
      lat: lat,
      lng: lng,
      isDefault: isDefault,
      storeId: storeId,
      isServiceable: isServiceable,
    );
  }
}
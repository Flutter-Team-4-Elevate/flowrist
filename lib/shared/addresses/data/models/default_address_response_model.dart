import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_address_response_model.g.dart';

@JsonSerializable()
class DefaultAddressResponseModel {
  final String addressId;
  final bool isDefault;
  final DateTime updatedAt;

  DefaultAddressResponseModel({
    required this.addressId,
    required this.isDefault,
    required this.updatedAt,
  });

  factory DefaultAddressResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DefaultAddressResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DefaultAddressResponseModelToJson(this);

  DefaultAddressEntity toEntity() {
    return DefaultAddressEntity(
      addressId: addressId,
      isDefault: isDefault,
      updatedAt: updatedAt,
    );
  }
}
class DefaultAddressEntity {
  final String addressId;
  final bool isDefault;
  final DateTime updatedAt;

  const DefaultAddressEntity({
    required this.addressId,
    required this.isDefault,
    required this.updatedAt,
  });
}
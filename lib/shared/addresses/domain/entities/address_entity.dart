class AddressEntity {
  final String id;
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final String city;
  final String area;
  final String? label;
  final double lat;
  final double lng;
  final bool isDefault;
  final String? storeId;
  final bool isServiceable;

  const AddressEntity({
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
  });
}
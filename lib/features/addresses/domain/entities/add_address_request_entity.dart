class AddAddressRequestEntity {
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final int governorateId;
  final int cityId;
  final String area;
  final double lat;
  final double lng;
  final String label;

  const AddAddressRequestEntity({
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
}

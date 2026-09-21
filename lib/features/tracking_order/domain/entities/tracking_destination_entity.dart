import 'package:equatable/equatable.dart';

class TrackingDestinationEntity extends Equatable {
  final double lat;
  final double lng;
  final String recipientName;
  final String addressLine;
  final String city;
  final String area;

  const TrackingDestinationEntity({
    required this.lat,
    required this.lng,
    required this.recipientName,
    required this.addressLine,
    required this.city,
    required this.area,
  });

  @override
  List<Object?> get props => [lat, lng, recipientName, addressLine, city, area];
}

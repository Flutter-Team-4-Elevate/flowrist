import 'package:equatable/equatable.dart';

class TrackingLocationEntity extends Equatable {
  final double lat;
  final double lng;

  const TrackingLocationEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

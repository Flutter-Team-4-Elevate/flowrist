import 'package:equatable/equatable.dart';

class TrackingDriverEntity extends Equatable {
  final String? id;
  final String? name;
  final String? phone;
  final String? image;

  const TrackingDriverEntity({this.id, this.name, this.phone, this.image});

  @override
  List<Object?> get props => [id, name, phone, image];
}

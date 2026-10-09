import 'package:equatable/equatable.dart';

class GovernorateEntity extends Equatable {
  final int? id;
  final String? nameAr;
  final String? nameEn;

  const GovernorateEntity({this.id, this.nameAr, this.nameEn});

  @override
  List<Object?> get props => [id, nameAr, nameEn];
}

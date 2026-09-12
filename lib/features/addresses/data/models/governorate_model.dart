import 'package:flowrist/shared/domain/entities/governorate_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'governorate_model.g.dart';

@JsonSerializable()
class GovernorateModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "nameAr")
  final String? nameAr;
  @JsonKey(name: "nameEn")
  final String? nameEn;

  GovernorateModel({this.id, this.nameAr, this.nameEn});

  GovernorateEntity toEntity() {
    return GovernorateEntity(id: id, nameAr: nameAr, nameEn: nameEn);
  }

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      _$GovernorateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateModelToJson(this);
}

import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "governorateId")
  final int? governorateId;
  @JsonKey(name: "nameAr")
  final String? nameAr;
  @JsonKey(name: "nameEn")
  final String? nameEn;

  CityModel({this.id, this.governorateId, this.nameAr, this.nameEn});

  CityEntity toEntity() {
    return CityEntity(
      id: id,
      governorateId: governorateId,
      nameAr: nameAr,
      nameEn: nameEn,
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

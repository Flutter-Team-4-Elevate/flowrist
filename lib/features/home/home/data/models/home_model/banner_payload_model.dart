import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/home_entities/banner_payload_entity.dart';
import 'home_payload_model.dart';

part 'banner_payload_model.g.dart';

@JsonSerializable()
class BannerPayloadModel extends HomePayloadModel {
  final String imageUrl;
  final String clickAction;

  const BannerPayloadModel({
    required super.type,
    required this.imageUrl,
    required this.clickAction,
  });

  factory BannerPayloadModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$BannerPayloadModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BannerPayloadModelToJson(this);

  @override
  BannerPayloadEntity toEntity() {
    return BannerPayloadEntity(
      type: type,
      imageUrl: imageUrl,
      clickAction: clickAction,
    );
  }
}
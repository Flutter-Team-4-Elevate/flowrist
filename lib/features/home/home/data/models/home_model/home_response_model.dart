 
import 'package:flowrist/features/home/home/data/factories/home_payload_model_factory.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/home_entities/home_layout_entity.dart';
import 'home_payload_model.dart';
 
 

part 'home_response_model.g.dart';

@JsonSerializable()
class HomeResponseModel {
  final String id;
  final String type;
  final String title;
  final int order;
  final bool isEnabled;

  @JsonKey(
    fromJson: _payloadFromJson,
    includeToJson: false,
  )
  final HomePayloadModel payload;

  const HomeResponseModel({
    required this.id,
    required this.type,
    required this.title,
    required this.order,
    required this.isEnabled,
    required this.payload,
  });

  factory HomeResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$HomeResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HomeResponseModelToJson(this);

  static HomePayloadModel _payloadFromJson(Object? json) {
    return const HomePayloadModelFactory().fromJson(
      json as Map<String, dynamic>,
    );
  }

  HomeLayoutEntity toEntity() {
    return HomeLayoutEntity(
      id: id,
      type: type,
      title: title,
      order: order,
      isEnabled: isEnabled,
      payload: payload.toEntity(),
    );
  }
}
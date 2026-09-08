import 'package:flowrist/features/home/home/data/models/home_model/home_payload_model.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/occasion_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/home_entities/occasion_rail_payload_entity.dart';
import 'occasion_item_model.dart';

part 'occasion_rail_payload_model.g.dart';

@JsonSerializable()
class OccasionRailPayloadModel extends HomePayloadModel {
  final List<OccasionItemModel> items;
  final String viewAllAction;

  const OccasionRailPayloadModel({
    required super.type,
    required this.items,
    required this.viewAllAction,
  });

  factory OccasionRailPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionRailPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionRailPayloadModelToJson(this);

  @override
  OccasionRailPayloadEntity toEntity() {
    return OccasionRailPayloadEntity(
      type: type,
      items: items
          .map(
            (item) => OccasionItemEntity(
              id: item.id,
              name: item.name,
              imageUrl: item.imageUrl,
            ),
          )
          .toList(),
      viewAllAction: viewAllAction,
    );
  }
}

import 'home_payload_entity.dart';
import 'occasion_item_entity.dart';

class OccasionRailPayloadEntity extends HomePayloadEntity {
  final List<OccasionItemEntity> items;
  final String viewAllAction;

  const OccasionRailPayloadEntity({
    required super.type,
    required this.items,
    required this.viewAllAction,
  });
}

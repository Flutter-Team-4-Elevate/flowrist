import 'home_payload_entity.dart';
import 'category_item_entity.dart';

class CategoryRailPayloadEntity extends HomePayloadEntity {
  final List<CategoryItemEntity> items;
  final String viewAllAction;

  const CategoryRailPayloadEntity({
    required this.items,
    required this.viewAllAction,
    required super.type,
  });
}

import 'home_payload_entity.dart';
import 'product_item_entity.dart';

class ProductRailPayloadEntity extends HomePayloadEntity {
  
  final List<ProductItemEntity> items;
  final String viewAllAction;

  const ProductRailPayloadEntity({
     
    required this.items,
    required this.viewAllAction, required super.type,
  });
}
import 'package:flowrist/features/home/home/data/models/home_model/home_payload_model.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/product_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/home_entities/product_rail_payload_entity.dart';
import 'product_item_model.dart';

part 'product_rail_payload_model.g.dart';

@JsonSerializable()
class ProductRailPayloadModel extends HomePayloadModel {
  final List<ProductItemModel> items;
  final String viewAllAction;

  const ProductRailPayloadModel({
    required super.type,
    required this.items,
    required this.viewAllAction,
  });

  factory ProductRailPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRailPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductRailPayloadModelToJson(this);

  @override
  ProductRailPayloadEntity toEntity() {
    return ProductRailPayloadEntity(
      type: type,
      items: items
          .map(
            (item) => ProductItemEntity(
              id: item.id,
              name: item.name,
              imageUrl: item.imageUrl,
              price: item.price,
            ),
          )
          .toList(),
      viewAllAction: viewAllAction,
    );
  }
}

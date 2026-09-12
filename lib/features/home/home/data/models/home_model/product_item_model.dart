import 'package:json_annotation/json_annotation.dart';

part 'product_item_model.g.dart';

@JsonSerializable()
class ProductItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  const ProductItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemModelToJson(this);
}

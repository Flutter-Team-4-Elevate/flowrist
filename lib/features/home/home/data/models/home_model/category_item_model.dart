import 'package:json_annotation/json_annotation.dart';

part 'category_item_model.g.dart';

@JsonSerializable()
class CategoryItemModel {
  final String id;
  final String name;
  final String iconUrl;

  const CategoryItemModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory CategoryItemModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CategoryItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoryItemModelToJson(this);
}
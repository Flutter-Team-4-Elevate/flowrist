import 'package:json_annotation/json_annotation.dart';


part 'occasion_item_model.g.dart';

 
@JsonSerializable()
class OccasionItemModel {
  final String id;
  final String name;
  final String imageUrl;

  const OccasionItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory OccasionItemModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$OccasionItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OccasionItemModelToJson(this);
}
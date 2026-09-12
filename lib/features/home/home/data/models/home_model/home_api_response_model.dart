 import 'package:json_annotation/json_annotation.dart';
import 'home_response_model.dart';

part 'home_api_response_model.g.dart';

@JsonSerializable()
class HomeApiResponseModel {
  final bool status;
  final int code;
  final String message;
  final List<HomeResponseModel> data;

  const HomeApiResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory HomeApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$HomeApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HomeApiResponseModelToJson(this);
}
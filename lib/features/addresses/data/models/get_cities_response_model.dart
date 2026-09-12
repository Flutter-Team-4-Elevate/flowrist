import 'package:flowrist/features/addresses/data/models/city_model.dart';
import 'package:flowrist/features/home/shared/pagination_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_cities_response_model.g.dart';

@JsonSerializable()
class GetCitiesResponseModel {
  final bool? status;
  final int? code;
  final String? message;
  final List<CityModel>? data;
  final PaginationDto? pagination;

  const GetCitiesResponseModel({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetCitiesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetCitiesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetCitiesResponseModelToJson(this);
}

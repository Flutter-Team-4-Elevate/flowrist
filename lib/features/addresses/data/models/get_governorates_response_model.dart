import 'package:flowrist/features/addresses/data/models/governorate_model.dart';
import 'package:flowrist/features/home/shared/pagination_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_governorates_response_model.g.dart';

@JsonSerializable()
class GetGovernoratesResponseModel {
  final bool? status;
  final int? code;
  final String? message;
  final List<GovernorateModel>? data;
  final PaginationDto? pagination;

  const GetGovernoratesResponseModel({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetGovernoratesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetGovernoratesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetGovernoratesResponseModelToJson(this);
}

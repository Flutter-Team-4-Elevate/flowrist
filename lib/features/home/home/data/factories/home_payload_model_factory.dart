import '../models/home_model/banner_payload_model.dart';
import '../models/home_model/category_rail_payload_model.dart';
import '../models/home_model/home_payload_model.dart';
import '../models/home_model/occasion_rail_payload_model.dart';
import '../models/home_model/product_rail_payload_model.dart';

class HomePayloadModelFactory {
  const HomePayloadModelFactory();

  HomePayloadModel fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'banner':
        return BannerPayloadModel.fromJson(json);

      case 'category_rail':
        return CategoryRailPayloadModel.fromJson(json);

      case 'product_rail':
        return ProductRailPayloadModel.fromJson(json);

      case 'occasion_rail':
        return OccasionRailPayloadModel.fromJson(json);

      default:
        throw UnsupportedError('Unknown home payload type: ${json['type']}');
    }
  }
}

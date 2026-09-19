import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

abstract interface class OccasionsRepository {
  Future<BaseResponse<List<OccasionEntity>>> getOccasions();
  Future<BaseResponse<List<ProductEntity>>> getProducts({
    String? occasionId,
    String? categoryId,
    String? sort,
  });
}

import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';

abstract interface class OccasionsRemoteDataSource {
  Future<OccasionsResponseDto> getOccasions();
  Future<ProductsResponseDto> getProducts({
    String? occasionId,
    String? categoryId,
  });
}

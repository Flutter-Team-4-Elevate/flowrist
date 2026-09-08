import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/occasions_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/mapper/occasions_mapper.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRepository)
class OccasionsRepositoryImpl implements OccasionsRepository {
  final OccasionsRemoteDataSource _remoteDataSource;

  OccasionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<OccasionEntity>>> getOccasions() async {
    try {
      final responseDto = await _remoteDataSource.getOccasions();
      final entities = OccasionsMapper.toOccasionEntities(responseDto);
      return SuccessResponse<List<OccasionEntity>>(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<OccasionEntity>>(e);
    }
  }

  @override
  Future<BaseResponse<List<ProductEntity>>> getProducts({
    String? occasionId,
    String? categoryId,
  }) async {
    try {
      final responseDto = await _remoteDataSource.getProducts(
        occasionId: occasionId,
        categoryId: categoryId,
      );
      final entities = OccasionsMapper.toProductEntities(responseDto);
      return SuccessResponse<List<ProductEntity>>(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<ProductEntity>>(e);
    }
  }
}

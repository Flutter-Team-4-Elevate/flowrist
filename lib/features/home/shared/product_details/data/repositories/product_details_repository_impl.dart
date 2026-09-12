import 'package:injectable/injectable.dart';

import 'package:flowrist/config/base_response/base_response.dart';

import '../../domain/repositories/product_details_repo.dart';
import '../data_source/contract/remote/product_details_remote_data_source.dart';
import '../models/product_details_request_dto.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<BaseResponse<ProductDetailsRequestDto>> getProductDetails(
      String productId,
      ) {
    return remoteDataSource.getProductDetails(productId);
  }
}
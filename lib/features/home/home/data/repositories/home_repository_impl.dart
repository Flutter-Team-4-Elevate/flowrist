import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/home_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_response_model.dart';

import 'package:injectable/injectable.dart';

import '../../domain/entities/home_entities/home_layout_entity.dart';
import '../../domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<HomeLayoutEntity>>> getHomeLayout() async {
    final response = await _remoteDataSource.getHomeLayout();
    switch (response) {
      case SuccessResponse<List<HomeResponseModel>>():
        return SuccessResponse(
          response.data?.map((e) => e.toEntity()).toList()??[],
        );
      case ErrorResponse<List<HomeResponseModel>>():
        return ErrorResponse(response.errorMessage);
    }
  }
}

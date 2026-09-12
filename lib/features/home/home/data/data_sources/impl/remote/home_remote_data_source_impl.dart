import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/client/home_api_client.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/home_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_response_model.dart';
 
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeApiClient _apiClient;

  HomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<List<HomeResponseModel>>> getHomeLayout() async {
    try {
      final response = await _apiClient.getHomeLayout();
      return SuccessResponse(response.data);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }
}

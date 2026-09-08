import 'package:flowrist/config/base_response/base_response.dart';

import 'package:flowrist/features/home/home/data/models/home_model/home_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<BaseResponse<List<HomeResponseModel>>> getHomeLayout();
}

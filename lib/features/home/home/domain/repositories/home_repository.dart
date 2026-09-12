import 'package:flowrist/config/base_response/base_response.dart';

import '../entities/home_entities/home_layout_entity.dart';

abstract interface class HomeRepository {
   Future<BaseResponse<List<HomeLayoutEntity>>> getHomeLayout();
}
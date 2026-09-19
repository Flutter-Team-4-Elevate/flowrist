import 'package:flowrist/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/home_entities/home_layout_entity.dart';
import '../repositories/home_repository.dart';

@LazySingleton()
class GetHomeLayoutUseCase {
  final HomeRepository repository;

  GetHomeLayoutUseCase(this.repository);

  Future<BaseResponse<List<HomeLayoutEntity>>> call() {
    return repository.getHomeLayout();
  }
}

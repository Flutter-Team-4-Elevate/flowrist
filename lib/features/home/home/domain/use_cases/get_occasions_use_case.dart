import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOccasionsUseCase {
  final OccasionsRepository _repository;

  GetOccasionsUseCase(this._repository);

  Future<BaseResponse<List<OccasionEntity>>> call() async {
    return await _repository.getOccasions();
  }
}

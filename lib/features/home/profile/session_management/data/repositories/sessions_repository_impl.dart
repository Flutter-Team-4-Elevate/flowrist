import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/data/data_sources/contract/sessions_remote_data_source.dart';
import 'package:flowrist/features/home/profile/session_management/data/mapper/session_mapper.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flowrist/features/home/profile/session_management/domain/repositories/sessions_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SessionsRepository)
class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsRemoteDataSource _remoteDataSource;

  SessionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<SessionEntity>>> getSessions() async {
    try {
      final responseDto = await _remoteDataSource.getSessions();
      final entities = SessionMapper.toSessionEntityList(responseDto);
      return SuccessResponse<List<SessionEntity>>(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<SessionEntity>>(e);
    }
  }

  @override
  Future<BaseResponse<void>> revokeSession(String sessionId) async {
    try {
      await _remoteDataSource.revokeSession(sessionId);
      return SuccessResponse<void>(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    }
  }
}

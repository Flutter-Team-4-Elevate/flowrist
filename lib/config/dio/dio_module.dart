import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(SessionService sessionService) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await sessionService.getToken();

            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (error, stackTrace) {
            log(
              'Failed to retrieve authentication token',
              error: error,
              stackTrace: stackTrace,
            );
          }

          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return dio;
  }
}

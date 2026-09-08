import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';

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
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => log(obj.toString()),
      ),
    );

    return dio;
  }
}

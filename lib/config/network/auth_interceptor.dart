import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthInterceptor extends QueuedInterceptor {
  final SessionService _sessionService;
  final Dio _refreshDio;

  Completer<bool>? _refreshCompleter;

  AuthInterceptor(
    this._sessionService,
    @Named(AppConstants.refreshDioName) this._refreshDio,
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _sessionService.getToken();
    if (token.isNotEmpty) {
      options.headers[AppConstants.authorizationHeaderKey] =
          '${AppConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final isUnauthorized = response?.statusCode == 401;
    final isAuthEndpoint =
        err.requestOptions.path.contains(Endpoints.refreshToken) ||
        err.requestOptions.path.contains(Endpoints.login);

    if (isUnauthorized && !isAuthEndpoint) {
      final isRefreshed = await _refreshToken();

      if (isRefreshed) {
        try {
          final newToken = await _sessionService.getToken();
          final requestOptions = err.requestOptions;

          requestOptions.headers[AppConstants.authorizationHeaderKey] =
              '${AppConstants.bearerPrefix}$newToken';

          final retryResponse = await _refreshDio.fetch(requestOptions);
          return handler.resolve(retryResponse);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      } else {
        await _onRefreshFailed();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      return await _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final currentToken = await _sessionService.getToken();
      final refreshToken = await _sessionService.getRefreshToken();

      if (refreshToken.isEmpty) {
        log('AuthInterceptor: RefreshToken is EMPTY!');
        _refreshCompleter!.complete(false);
        return false;
      }

      final Map<String, dynamic> headers = {
        AppConstants.contentTypeHeaderKey: AppConstants.applicationJson,
      };

      if (currentToken.isNotEmpty) {
        headers[AppConstants.authorizationHeaderKey] =
            '${AppConstants.bearerPrefix}$currentToken';
      }

      final response = await _refreshDio.post(
        Endpoints.refreshToken,
        options: Options(headers: headers),
        data: {AppConstants.refreshTokenKey: refreshToken},
      );

      if (response.statusCode == 200 &&
          response.data[AppConstants.statusKey] == true) {
        final data = response.data[AppConstants.dataKey];
        final String newToken = data[AppConstants.tokenKey];
        final String newRefreshToken = data[AppConstants.refreshTokenKey];

        await _sessionService.updateTokens(
          token: newToken,
          refreshToken: newRefreshToken,
        );

        _refreshCompleter!.complete(true);
        return true;
      } else {
        log('AuthInterceptor: Refresh failed with response: ${response.data}');
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e, stack) {
      log('AuthInterceptor: Refresh Exception: $e', stackTrace: stack);
      _refreshCompleter!.complete(false);
      return false;
    }
  }

  Future<void> _onRefreshFailed() async {
    await _sessionService.clearSession();

    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      AppRouter.router.go(AppRoutes.login);
    }
  }
}

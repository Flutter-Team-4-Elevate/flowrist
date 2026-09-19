import 'package:dio/dio.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/core/constants/app_strings.dart';

abstract final class ApiErrorHandler {
  static ErrorResponse<T> handleException<T>(Exception exception) {
    if (exception is! DioException) {
      return ErrorResponse<T>(AppStrings.generalErrorMessage);
    }

    String errorMessage = '';
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorMessage = AppStrings.connectionErrorMessage;

      case DioExceptionType.connectionError:
        errorMessage = AppStrings.noConnectionErrorMessage;

      case DioExceptionType.badCertificate:
        errorMessage = AppStrings.securityErrorMessage;

      case DioExceptionType.cancel:
        errorMessage = AppStrings.cancelErrorMessage;

      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        if (exception.response != null) {
          return _handleStatusCode<T>(exception.response!);
        }
        errorMessage = AppStrings.generalErrorMessage;
      default:
        errorMessage = AppStrings.generalErrorMessage;
    }

    return ErrorResponse<T>(errorMessage);
  }

  static ErrorResponse<T> _handleStatusCode<T>(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    String serverMessage = '';
    if (data is Map<String, dynamic>) {
      serverMessage = data['message'] ?? '';
    }

    switch (statusCode) {
      case 400:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code400Message;

      case 401:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code401Message;

      case 403:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code403Message;

      case 404:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code404Message;

      case 409:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code409Message;

      case 422:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code422Message;

      case 429:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code429Message;

      case 500:
      case 502:
      case 503:
      case 504:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.code500sMessage;

      default:
        serverMessage = serverMessage.isNotEmpty
            ? serverMessage
            : AppStrings.generalErrorMessage;
    }

    return ErrorResponse<T>(serverMessage);
  }
}

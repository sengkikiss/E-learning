import 'package:dio/dio.dart';
import '../error/app_exception.dart';

class ApiExceptionHandler {
  ApiExceptionHandler._();

  static AppException fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('Connection timed out or lost. Please verify your connection.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Unexpected error occurred.';

        if (data is Map<String, dynamic> && data['message'] != null) {
          message = data['message'].toString();
        } else if (error.message != null && error.message!.isNotEmpty) {
          message = error.message!;
        }

        switch (statusCode) {
          case 400:
            return ValidationException(message, data);
          case 401:
            return UnauthorizedException(message);
          case 403:
            return ForbiddenException(message);
          case 404:
            return NotFoundException(message);
          case 500:
          default:
            return ServerException(message, statusCode);
        }

      case DioExceptionType.cancel:
        return const AppException('Request was cancelled.');

      case DioExceptionType.unknown:
      default:
        return AppException(error.message ?? 'An unknown error occurred.');
    }
  }
}

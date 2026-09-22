import 'app_exception.dart';
import 'failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(dynamic error) {
    if (error is AppException) {
      if (error is NetworkException) {
        return NetworkFailure(error.message);
      } else if (error is UnauthorizedException) {
        return AuthFailure(error.message, statusCode: 401);
      } else if (error is ForbiddenException) {
        return AuthFailure(error.message, statusCode: 403);
      } else if (error is NotFoundException) {
        return NotFoundFailure(error.message);
      } else if (error is ValidationException) {
        return ValidationFailure(error.message);
      } else if (error is CacheException) {
        return CacheFailure(error.message);
      } else {
        return ServerFailure(error.message, statusCode: error.statusCode);
      }
    }

    return ServerFailure(error.toString());
  }
}

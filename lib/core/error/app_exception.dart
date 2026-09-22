class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network connection error. Please check your internet.'])
      : super(message, statusCode: -1);
}

class ServerException extends AppException {
  const ServerException([String message = 'Server error occurred. Please try again later.', int? statusCode])
      : super(message, statusCode: statusCode ?? 500);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Session expired or unauthorized. Please login again.'])
      : super(message, statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'You do not have permission to access this resource.'])
      : super(message, statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Requested resource was not found.'])
      : super(message, statusCode: 404);
}

class ValidationException extends AppException {
  const ValidationException([String message = 'Invalid input provided.', dynamic details])
      : super(message, statusCode: 422, details: details);
}

class CacheException extends AppException {
  const CacheException([String message = 'Local storage caching error.'])
      : super(message);
}

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network connection error. Please check your internet.'])
      : super(statusCode: -1);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred. Please try again later.', int? statusCode])
      : super(statusCode: statusCode ?? 500);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired or unauthorized. Please login again.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You do not have permission to access this resource.'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Requested resource was not found.'])
      : super(statusCode: 404);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input provided.', dynamic details])
      : super(statusCode: 422, details: details);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local storage caching error.']);
}

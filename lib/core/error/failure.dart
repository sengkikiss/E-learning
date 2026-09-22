abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection unavailable.'])
      : super(message, statusCode: -1);
}

class AuthFailure extends Failure {
  const AuthFailure(String message, {int? statusCode = 401})
      : super(message, statusCode: statusCode);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message, statusCode: 422);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message, statusCode: 404);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

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
  const ServerFailure(super.message, {super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection unavailable.'])
      : super(statusCode: -1);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.statusCode = 401});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(statusCode: 422);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message) : super(statusCode: 404);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

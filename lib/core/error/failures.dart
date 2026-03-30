import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure({
    this.message,
    this.statusCode,
    this.userId,
    this.context,
  });

  final String? message;
  final int? statusCode;
  final int? userId;

  final Map<String, dynamic>? context;

  String get errorMessage => '$statusCode Error: $message';

  @override
  String toString() => message ?? '';

  @override
  List<Object> get props => [
        message ?? '',
        statusCode ?? 0,
        userId ?? 0,
      ];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message,
    super.statusCode,
    super.userId,
    super.context,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message,
    super.statusCode,
    super.userId,
    super.context,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message,
    super.statusCode,
    super.userId,
    super.context,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message,
    super.statusCode,
    super.userId,
    super.context,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message,
    super.statusCode,
    super.userId,
    super.context,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message,
    super.statusCode,
    super.userId,
    super.context,
  });
}

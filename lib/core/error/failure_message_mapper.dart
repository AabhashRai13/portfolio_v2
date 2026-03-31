import 'package:my_portfolio/core/error/failures.dart';

String mapFailureToMessage(
  Failure failure, {
  required String fallbackMessage,
}) {
  if (failure is PermissionFailure) {
    return 'You do not have permission to perform this action.';
  }

  if (failure is NotFoundFailure) {
    return 'The requested content could not be found.';
  }

  if (failure is TimeoutFailure) {
    return 'The request timed out. Please try again.';
  }

  if (failure is NetworkFailure) {
    return 'Please check your connection and try again.';
  }

  if (failure is ServerFailure &&
      failure.context?['code'] == 'failed-precondition') {
    return 'Comments are still being wired up on the backend. Please try '
        'again in a minute.';
  }

  if ((failure.message ?? '').trim().isNotEmpty) {
    return failure.message!;
  }

  return fallbackMessage;
}

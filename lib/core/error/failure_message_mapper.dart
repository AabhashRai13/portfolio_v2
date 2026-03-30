import 'package:my_portfolio/core/error/failures.dart';

String mapFailureToMessage(
  Failure failure, {
  required String fallbackMessage,
}) {
  if ((failure.message ?? '').trim().isNotEmpty) {
    return failure.message!;
  }

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

  return fallbackMessage;
}

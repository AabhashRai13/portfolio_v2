import 'dart:async';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:my_portfolio/core/error/failures.dart';
import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/newsletter/data/datasources/newsletter_remote_data_source.dart';
import 'package:my_portfolio/features/newsletter/domain/entities/subscription_result.dart';
import 'package:my_portfolio/features/newsletter/domain/repositories/newsletter_repository.dart';

/// Subscribes readers to Buttondown through the `subscribeToNewsletter`
/// Cloud Function so the Buttondown API key stays server-side and never
/// ships in the public web bundle.
class ButtondownNewsletterRepository implements NewsletterRepository {
  ButtondownNewsletterRepository({
    required NewsletterRemoteDataSource remoteDataSource,
    this.timeout = const Duration(seconds: 12),
  }) : _remoteDataSource = remoteDataSource;

  final NewsletterRemoteDataSource _remoteDataSource;
  final Duration timeout;

  static const String _alreadySubscribedResult = 'already_subscribed';

  @override
  ResultFuture<SubscriptionResult> subscribe(String email) async {
    try {
      final data = await _remoteDataSource.subscribe(email).timeout(timeout);
      final result = data is Map<Object?, Object?> ? data['result'] : null;

      return Right(
        result == _alreadySubscribedResult
            ? SubscriptionResult.alreadySubscribed
            : SubscriptionResult.success,
      );
    } on FirebaseFunctionsException catch (error, stackTrace) {
      _logFailure(error, stackTrace);
      return Left(_mapFunctionsException(error));
    } on TimeoutException catch (error, stackTrace) {
      _logFailure(error, stackTrace);
      return const Left(
        TimeoutFailure(
          message: 'The request took too long. Please try again.',
        ),
      );
    } on Exception catch (error, stackTrace) {
      _logFailure(error, stackTrace);
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapFunctionsException(FirebaseFunctionsException error) {
    final context = <String, dynamic>{'code': error.code};

    switch (error.code) {
      case 'unavailable':
        return NetworkFailure(
          message: 'The newsletter service is unreachable right now. '
              'Please try again later.',
          context: context,
        );
      case 'deadline-exceeded':
        return TimeoutFailure(
          message: 'The newsletter service took too long to respond.',
          context: context,
        );
      case 'unauthenticated':
      case 'permission-denied':
        return PermissionFailure(context: context);
      default:
        return ServerFailure(message: error.message, context: context);
    }
  }

  void _logFailure(Object error, StackTrace stackTrace) {
    log(
      'Newsletter subscribe failed',
      error: error,
      stackTrace: stackTrace,
      name: 'ButtondownNewsletterRepository',
    );
  }
}

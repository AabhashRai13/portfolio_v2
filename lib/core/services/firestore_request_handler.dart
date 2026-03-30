import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:my_portfolio/core/error/exceptions.dart';
import 'package:my_portfolio/core/error/failures.dart';
import 'package:my_portfolio/core/resources/typedef.dart';

class FirestoreRequestHandler {
  const FirestoreRequestHandler({
    this.timeout = const Duration(seconds: 12),
  });

  final Duration timeout;

  ResultFuture<T> run<T>({
    required Future<T> Function() request,
    required String operation,
    required String fallbackMessage,
    DataMap? context,
  }) async {
    try {
      final result = await request().timeout(timeout);
      return Right(result);
    } on FirebaseException catch (error, stackTrace) {
      _logFailure(operation, error, stackTrace, context);
      return Left(
        _mapFirebaseFailure(
          error,
          fallbackMessage: fallbackMessage,
          context: context,
        ),
      );
    } on TimeoutException catch (error, stackTrace) {
      _logFailure(operation, error, stackTrace, context);
      return Left(
        TimeoutFailure(
          message: 'The request took too long. Please try again.',
          context: <String, dynamic>{
            ...?context,
            'operation': operation,
          },
        ),
      );
    } on NotFoundException catch (error, stackTrace) {
      _logFailure(operation, error, stackTrace, context);
      return Left(
        NotFoundFailure(
          message: error.message,
          context: <String, dynamic>{
            ...?context,
            'operation': operation,
          },
        ),
      );
    } on Exception catch (error, stackTrace) {
      _logFailure(operation, error, stackTrace, context);
      return Left(
        UnexpectedFailure(
          message: fallbackMessage,
          context: <String, dynamic>{
            ...?context,
            'operation': operation,
            'error': error.toString(),
          },
        ),
      );
    }
  }

  ResultVoid runVoid({
    required Future<void> Function() request,
    required String operation,
    required String fallbackMessage,
    DataMap? context,
  }) async {
    final result = await run<void>(
      request: request,
      operation: operation,
      fallbackMessage: fallbackMessage,
      context: context,
    );

    return result;
  }

  Failure _mapFirebaseFailure(
    FirebaseException error, {
    required String fallbackMessage,
    DataMap? context,
  }) {
    final enrichedContext = <String, dynamic>{
      ...?context,
      'plugin': error.plugin,
      'code': error.code,
    };

    switch (error.code) {
      case 'permission-denied':
        return PermissionFailure(
          message: 'Firestore denied this request. Check your rules.',
          context: enrichedContext,
        );
      case 'not-found':
        return NotFoundFailure(
          message: 'The requested Firestore document was not found.',
          context: enrichedContext,
        );
      case 'unavailable':
      case 'network-request-failed':
        return NetworkFailure(
          message: 'Firestore is currently unreachable. Check your network.',
          context: enrichedContext,
        );
      case 'deadline-exceeded':
        return TimeoutFailure(
          message: 'Firestore took too long to respond.',
          context: enrichedContext,
        );
      case 'failed-precondition':
        return ServerFailure(
          message:
              'Firestore is missing a required index or precondition. '
              'Please verify the backend setup.',
          context: enrichedContext,
        );
      default:
        return ServerFailure(
          message: error.message ?? fallbackMessage,
          context: enrichedContext,
        );
    }
  }

  void _logFailure(
    String operation,
    Object error,
    StackTrace stackTrace,
    DataMap? context,
  ) {
    log(
      'Firestore request failed: $operation',
      error: error,
      stackTrace: stackTrace,
      name: 'FirestoreRequestHandler',
    );

    if (context != null && context.isNotEmpty) {
      log(
        'Firestore context: $context',
        name: 'FirestoreRequestHandler',
      );
    }
  }
}

import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_portfolio/core/error/failures.dart';
import 'package:my_portfolio/features/newsletter/data/repositories/buttondown_newsletter_repository.dart';
import 'package:my_portfolio/features/newsletter/domain/entities/subscription_result.dart';

import '../newsletter_mocks.mocks.dart';

void main() {
  const email = 'aabhash@example.com';

  late MockNewsletterRemoteDataSource remoteDataSource;
  late ButtondownNewsletterRepository repository;

  setUp(() {
    remoteDataSource = MockNewsletterRemoteDataSource();
    repository = ButtondownNewsletterRepository(
      remoteDataSource: remoteDataSource,
      timeout: const Duration(milliseconds: 200),
    );
  });

  group('ButtondownNewsletterRepository.subscribe', () {
    test('returns success when the function reports success', () async {
      when(remoteDataSource.subscribe(email)).thenAnswer(
        (_) async => <Object?, Object?>{'result': 'success'},
      );

      final result = await repository.subscribe(email);

      expect(
        result.getOrElse(() => fail('expected a Right')),
        SubscriptionResult.success,
      );
    });

    test('returns alreadySubscribed when the function reports a duplicate',
        () async {
      when(remoteDataSource.subscribe(email)).thenAnswer(
        (_) async => <Object?, Object?>{'result': 'already_subscribed'},
      );

      final result = await repository.subscribe(email);

      expect(
        result.getOrElse(() => fail('expected a Right')),
        SubscriptionResult.alreadySubscribed,
      );
    });

    test('maps an unavailable function to a NetworkFailure', () async {
      when(remoteDataSource.subscribe(email)).thenThrow(
        FirebaseFunctionsException(
          message: 'unavailable',
          code: 'unavailable',
        ),
      );

      final result = await repository.subscribe(email);

      final failure = result.swap().getOrElse(() => fail('expected a Left'));
      expect(failure, isA<NetworkFailure>());
    });

    test('maps a deadline-exceeded function to a TimeoutFailure', () async {
      when(remoteDataSource.subscribe(email)).thenThrow(
        FirebaseFunctionsException(
          message: 'deadline exceeded',
          code: 'deadline-exceeded',
        ),
      );

      final result = await repository.subscribe(email);

      final failure = result.swap().getOrElse(() => fail('expected a Left'));
      expect(failure, isA<TimeoutFailure>());
    });

    test('maps an App Check rejection to a PermissionFailure', () async {
      when(remoteDataSource.subscribe(email)).thenThrow(
        FirebaseFunctionsException(
          message: 'unauthenticated',
          code: 'unauthenticated',
        ),
      );

      final result = await repository.subscribe(email);

      final failure = result.swap().getOrElse(() => fail('expected a Left'));
      expect(failure, isA<PermissionFailure>());
    });

    test('surfaces the function message for other function errors', () async {
      when(remoteDataSource.subscribe(email)).thenThrow(
        FirebaseFunctionsException(
          message: 'Buttondown rejected that email address.',
          code: 'invalid-argument',
        ),
      );

      final result = await repository.subscribe(email);

      final failure = result.swap().getOrElse(() => fail('expected a Left'));
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Buttondown rejected that email address.');
    });

    test('maps a hung call to a TimeoutFailure', () async {
      when(remoteDataSource.subscribe(email)).thenAnswer(
        (_) => Completer<Object?>().future,
      );

      final result = await repository.subscribe(email);

      final failure = result.swap().getOrElse(() => fail('expected a Left'));
      expect(failure, isA<TimeoutFailure>());
    });

    test('maps unknown exceptions to an UnexpectedFailure', () async {
      when(remoteDataSource.subscribe(email))
          .thenThrow(const FormatException('bad payload'));

      final result = await repository.subscribe(email);

      final failure = result.swap().getOrElse(() => fail('expected a Left'));
      expect(failure, isA<UnexpectedFailure>());
    });
  });
}

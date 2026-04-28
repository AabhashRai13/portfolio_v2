import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/error/failures.dart';
import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/newsletter/domain/entities/subscription_result.dart';
import 'package:my_portfolio/features/newsletter/domain/repositories/newsletter_repository.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';

void main() {
  group('NewsletterController.subscribeWithEmail', () {
    test('reports success and clears the email field', () async {
      final controller = NewsletterController(
        newsletterRepository: _FakeNewsletterRepository(
          response: const Right(SubscriptionResult.success),
        ),
      );
      addTearDown(controller.dispose);
      controller.emailController.text = 'aabhash@example.com';

      await controller.subscribeWithEmail('aabhash@example.com');

      expect(controller.subscribeCommand.error, isNull);
      expect(
        controller.subscribeCommand.data,
        "You're on the list! Check your inbox to confirm.",
      );
      expect(controller.emailController.text, isEmpty);
    });

    test('reports already-subscribed without clearing the field', () async {
      final controller = NewsletterController(
        newsletterRepository: _FakeNewsletterRepository(
          response: const Right(SubscriptionResult.alreadySubscribed),
        ),
      );
      addTearDown(controller.dispose);
      controller.emailController.text = 'aabhash@example.com';

      await controller.subscribeWithEmail('aabhash@example.com');

      expect(controller.subscribeCommand.error, isNull);
      expect(controller.subscribeCommand.data, "You're already subscribed.");
      expect(controller.emailController.text, 'aabhash@example.com');
    });

    test('maps NetworkFailure to a user-friendly message', () async {
      final controller = NewsletterController(
        newsletterRepository: _FakeNewsletterRepository(
          response: const Left(NetworkFailure()),
        ),
      );
      addTearDown(controller.dispose);

      await controller.subscribeWithEmail('aabhash@example.com');

      expect(controller.subscribeCommand.data, isNull);
      expect(
        controller.subscribeCommand.error,
        'Please check your connection and try again.',
      );
    });

    test('falls back when failure has no message', () async {
      final controller = NewsletterController(
        newsletterRepository: _FakeNewsletterRepository(
          response: const Left(ServerFailure()),
        ),
      );
      addTearDown(controller.dispose);

      await controller.subscribeWithEmail('aabhash@example.com');

      expect(controller.subscribeCommand.data, isNull);
      expect(
        controller.subscribeCommand.error,
        'Could not subscribe right now, please try again later.',
      );
    });
  });
}

class _FakeNewsletterRepository implements NewsletterRepository {
  _FakeNewsletterRepository({required this.response});

  final Either<Failure, SubscriptionResult> response;

  @override
  ResultFuture<SubscriptionResult> subscribe(String email) async => response;
}

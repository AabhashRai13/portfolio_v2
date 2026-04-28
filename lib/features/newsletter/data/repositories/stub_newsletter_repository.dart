import 'package:dartz/dartz.dart';
import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/newsletter/domain/entities/subscription_result.dart';
import 'package:my_portfolio/features/newsletter/domain/repositories/newsletter_repository.dart';

// Placeholder until the Buttondown API key is approved.
// Swap this for ButtondownNewsletterRepository in service_locator once ready.
class StubNewsletterRepository implements NewsletterRepository {
  const StubNewsletterRepository();

  @override
  ResultFuture<SubscriptionResult> subscribe(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const Right(SubscriptionResult.success);
  }
}

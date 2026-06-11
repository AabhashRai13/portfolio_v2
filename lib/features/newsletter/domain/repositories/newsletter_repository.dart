import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/newsletter/domain/entities/subscription_result.dart';

// This abstraction is intentional so the UI/domain layers depend on a
// repository contract, not Buttondown directly.
// ignore: one_member_abstracts
abstract class NewsletterRepository {
  ResultFuture<SubscriptionResult> subscribe(String email);
}

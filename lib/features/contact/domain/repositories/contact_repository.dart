import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';

// This abstraction is intentional so the UI/domain layers depend on a
// repository contract, not EmailJS directly.
// ignore: one_member_abstracts
abstract class ContactRepository {
  Future<void> submitContactMessage(ContactMessage message);
}

import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';

class SubmitContactMessageUseCase {
  const SubmitContactMessageUseCase(this._contactRepository);

  final ContactRepository _contactRepository;

  Future<void> call(ContactMessage message) {
    return _contactRepository.submitContactMessage(message);
  }
}

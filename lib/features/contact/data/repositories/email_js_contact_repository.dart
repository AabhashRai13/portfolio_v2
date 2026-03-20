import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/keys.dart';

class EmailJsContactRepository implements ContactRepository {
  @override
  Future<void> submitContactMessage(ContactMessage message) {
    return emailjs.send(
      emailJsServiceId,
      emailJsTemplateId,
      message.toTemplateParams(),
      const emailjs.Options(
        publicKey: emailJsPublicKey,
        privateKey: emailJsPrivateKey,
      ),
    );
  }
}

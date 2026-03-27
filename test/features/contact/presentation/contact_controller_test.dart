import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/domain/usecases/submit_contact_message_use_case.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';

void main() {
  group('ContactController', () {
    test('submitMessage reports success and clears the form', () async {
      final controller = ContactController(
        submitContactMessage: SubmitContactMessageUseCase(
          _FakeContactRepository(),
        ),
        launchService: const _FakeLaunchService(),
      );
      addTearDown(controller.dispose);

      controller.nameController.text = 'Aabhash';
      controller.emailController.text = 'aabhash@example.com';
      controller.phoneController.text = '123';
      controller.messageController.text = 'Hello';

      await controller.submitMessage(controller.contactMessage);

      expect(controller.submitCommand.error, isNull);
      expect(controller.submitCommand.data, 'Form submitted successfully');
      expect(controller.nameController.text, isEmpty);
      expect(controller.emailController.text, isEmpty);
      expect(controller.phoneController.text, isEmpty);
      expect(controller.messageController.text, isEmpty);
    });

    test('submitMessage reports failure when repository throws', () async {
      final controller = ContactController(
        submitContactMessage: SubmitContactMessageUseCase(
          _FakeContactRepository(shouldThrow: true),
        ),
        launchService: const _FakeLaunchService(),
      );
      addTearDown(controller.dispose);

      await controller.submitMessage(
        const ContactMessage(
          name: 'Aabhash',
          email: 'aabhash@example.com',
          phone: '123',
          message: 'Hello',
        ),
      );

      expect(controller.submitCommand.data, isNull);
      expect(
        controller.submitCommand.error,
        'Failed to submit form, please try again later.',
      );
    });
  });
}

class _FakeContactRepository implements ContactRepository {
  _FakeContactRepository({this.shouldThrow = false});

  final bool shouldThrow;

  @override
  Future<void> submitContactMessage(ContactMessage message) async {
    if (shouldThrow) {
      throw Exception('boom');
    }
  }
}

class _FakeLaunchService implements AppLaunchService {
  const _FakeLaunchService();

  @override
  Future<void> openExternalUrl(String url) async {}
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_topic.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';

void main() {
  group('ContactController', () {
    test('submitMessage reports success and clears the form', () async {
      final controller = ContactController(
        contactRepository: _FakeContactRepository(),
        launchService: const _FakeLaunchService(),
      );
      addTearDown(controller.dispose);

      controller.nameController.text = 'Aabhash';
      controller.emailController.text = 'aabhash@example.com';
      controller.messageController.text = 'Hello';

      await controller.submitMessage(controller.contactMessage);

      expect(controller.submitCommand.error, isNull);
      expect(controller.submitCommand.data, 'Form submitted successfully');
      expect(controller.nameController.text, isEmpty);
      expect(controller.emailController.text, isEmpty);
      expect(controller.messageController.text, isEmpty);
    });

    test('contactMessage leads with the chosen topic', () {
      final controller = ContactController(
        contactRepository: _FakeContactRepository(),
        launchService: const _FakeLaunchService(),
      );
      addTearDown(controller.dispose);

      controller.messageController.text = 'Need an MVP';
      controller.toggleTopic(ContactTopic.newApp);
      expect(
        controller.contactMessage.message,
        'Topic: New app\n\nNeed an MVP',
      );

      controller.toggleTopic(ContactTopic.newApp);
      expect(controller.topic.value, isNull);
      expect(controller.contactMessage.message, 'Need an MVP');
    });

    test('success records the reply address and resets the topic', () async {
      final repository = _FakeContactRepository();
      final controller = ContactController(
        contactRepository: repository,
        launchService: const _FakeLaunchService(),
      );
      addTearDown(controller.dispose);

      controller
        ..toggleTopic(ContactTopic.hiring)
        ..nameController.text = 'Sam'
        ..emailController.text = 'sam@example.com'
        ..messageController.text = 'Senior role';
      await controller.submitMessage(controller.contactMessage);

      expect(controller.sentTo.value, 'sam@example.com');
      expect(controller.topic.value, isNull);
      expect(
        repository.sent.single.toTemplateParams(),
        <String, dynamic>{
          'name': 'Sam',
          'email': 'sam@example.com',
          'message': 'Topic: Hiring\n\nSenior role',
        },
      );

      controller.startNewMessage();
      expect(controller.sentTo.value, isNull);
    });

    test('submitMessage reports failure when repository throws', () async {
      final controller = ContactController(
        contactRepository: _FakeContactRepository(shouldThrow: true),
        launchService: const _FakeLaunchService(),
      );
      addTearDown(controller.dispose);

      await controller.submitMessage(
        const ContactMessage(
          name: 'Aabhash',
          email: 'aabhash@example.com',
          message: 'Hello',
        ),
      );

      expect(controller.submitCommand.data, isNull);
      expect(
        controller.submitCommand.error,
        'Failed to submit form, please try again later.',
      );
    });

    for (final fails in [false, true]) {
      test(
        'submitMessage finishing after dispose is a no-op '
        '(${fails ? 'failure' : 'success'})',
        () async {
          final gate = Completer<void>();
          final controller = ContactController(
            contactRepository: _FakeContactRepository(
              shouldThrow: fails,
              gate: gate.future,
            ),
            launchService: const _FakeLaunchService(),
          );

          final submit = controller.submitMessage(
            const ContactMessage(
              name: 'Aabhash',
              email: 'aabhash@example.com',
              message: 'Hello',
            ),
          );
          controller.dispose();
          gate.complete();

          await expectLater(submit, completes);
        },
      );
    }
  });
}

class _FakeContactRepository implements ContactRepository {
  _FakeContactRepository({this.shouldThrow = false, this.gate});

  final bool shouldThrow;

  /// When set, the submit stays pending until this future completes.
  final Future<void>? gate;

  final List<ContactMessage> sent = <ContactMessage>[];

  @override
  Future<void> submitContactMessage(ContactMessage message) async {
    sent.add(message);
    await gate;
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

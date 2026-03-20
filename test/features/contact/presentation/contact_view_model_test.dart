import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/domain/usecases/submit_contact_message_use_case.dart';
import 'package:my_portfolio/features/contact/presentation/view_models/contact_view_model.dart';

void main() {
  group('ContactViewModel', () {
    test('submitMessage reports success and clears the form', () async {
      final viewModel = ContactViewModel(
        submitContactMessage: SubmitContactMessageUseCase(
          _FakeContactRepository(),
        ),
        launchService: const _FakeLaunchService(),
      );

      viewModel.nameController.text = 'Aabhash';
      viewModel.emailController.text = 'aabhash@example.com';
      viewModel.phoneController.text = '123';
      viewModel.messageController.text = 'Hello';

      await viewModel.submitMessage(viewModel.contactMessage);

      expect(viewModel.submitCommand.error, isNull);
      expect(viewModel.submitCommand.data, 'Form submitted successfully');
      expect(viewModel.nameController.text, isEmpty);
      expect(viewModel.emailController.text, isEmpty);
      expect(viewModel.phoneController.text, isEmpty);
      expect(viewModel.messageController.text, isEmpty);
    });

    test('submitMessage reports failure when repository throws', () async {
      final viewModel = ContactViewModel(
        submitContactMessage: SubmitContactMessageUseCase(
          _FakeContactRepository(shouldThrow: true),
        ),
        launchService: const _FakeLaunchService(),
      );

      await viewModel.submitMessage(
        const ContactMessage(
          name: 'Aabhash',
          email: 'aabhash@example.com',
          phone: '123',
          message: 'Hello',
        ),
      );

      expect(viewModel.submitCommand.data, isNull);
      expect(
        viewModel.submitCommand.error,
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

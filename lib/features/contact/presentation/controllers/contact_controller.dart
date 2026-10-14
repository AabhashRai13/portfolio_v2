import 'package:flutter/material.dart';
import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_topic.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';

class ContactController {
  ContactController({
    required ContactRepository contactRepository,
    required AppLaunchService launchService,
  }) : _contactRepository = contactRepository,
       _launchService = launchService;

  final ContactRepository _contactRepository;
  final AppLaunchService _launchService;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  /// The optional quick-start topic; it leads the sent message.
  final ValueNotifier<ContactTopic?> topic = ValueNotifier<ContactTopic?>(
    null,
  );

  /// The reply address of the last message sent; non-null shows the
  /// success state until [startNewMessage].
  final ValueNotifier<String?> sentTo = ValueNotifier<String?>(null);

  final Command<String?> submitCommand = Command<String?>(data: null);

  bool _isDisposed = false;

  ContactMessage get contactMessage {
    final text = messageController.text.trim();
    final chosen = topic.value;
    return ContactMessage(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      message: chosen == null ? text : 'Topic: ${chosen.label}\n\n$text',
    );
  }

  void toggleTopic(ContactTopic value) {
    topic.value = topic.value == value ? null : value;
  }

  Future<void> submit() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    await submitMessage(contactMessage);
  }

  Future<void> submitMessage(ContactMessage message) async {
    submitCommand.toggleLoading();

    try {
      await _contactRepository.submitContactMessage(message);
      if (_isDisposed) return;
      sentTo.value = message.email;
      clearForm();
      submitCommand.setData('Form submitted successfully');
    } on Exception {
      if (_isDisposed) return;
      submitCommand.setError(
        'Failed to submit form, please try again later.',
      );
    }
  }

  void startNewMessage() {
    sentTo.value = null;
  }

  Future<void> openSocialLink(String url) {
    return _launchService.openExternalUrl(url);
  }

  void resetSubmitFeedback() {
    submitCommand.setData(null);
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    messageController.clear();
    topic.value = null;
  }

  void dispose() {
    _isDisposed = true;
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    topic.dispose();
    sentTo.dispose();
    submitCommand.dispose();
  }
}

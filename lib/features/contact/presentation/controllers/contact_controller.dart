import 'package:flutter/material.dart';
import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/usecases/submit_contact_message_use_case.dart';

class ContactController {
  ContactController({
    required SubmitContactMessageUseCase submitContactMessage,
    required AppLaunchService launchService,
  }) : _submitContactMessage = submitContactMessage,
       _launchService = launchService;

  final SubmitContactMessageUseCase _submitContactMessage;
  final AppLaunchService _launchService;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final phoneController = TextEditingController();

  final Command<String?> submitCommand = Command<String?>(data: null);

  ContactMessage get contactMessage => ContactMessage(
    name: nameController.text.trim(),
    email: emailController.text.trim(),
    phone: phoneController.text.trim(),
    message: messageController.text.trim(),
  );

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
      await _submitContactMessage(message);
      clearForm();
      submitCommand.setData('Form submitted successfully');
    } on Exception {
      submitCommand.setError(
        'Failed to submit form, please try again later.',
      );
    }
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
    phoneController.clear();
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    phoneController.dispose();
    submitCommand.dispose();
  }
}

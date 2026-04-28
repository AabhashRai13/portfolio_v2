import 'package:flutter/material.dart';
import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/error/failure_message_mapper.dart';
import 'package:my_portfolio/features/newsletter/domain/entities/subscription_result.dart';
import 'package:my_portfolio/features/newsletter/domain/repositories/newsletter_repository.dart';

class NewsletterController {
  NewsletterController({required NewsletterRepository newsletterRepository})
    : _newsletterRepository = newsletterRepository;

  final NewsletterRepository _newsletterRepository;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final Command<String?> subscribeCommand = Command<String?>(data: null);

  Future<void> subscribe() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    await subscribeWithEmail(emailController.text.trim());
  }

  Future<void> subscribeWithEmail(String email) async {
    subscribeCommand.start();

    final result = await _newsletterRepository.subscribe(email);
    result.fold(
      (failure) => subscribeCommand.setError(
        mapFailureToMessage(
          failure,
          fallbackMessage:
              'Could not subscribe right now, please try again later.',
        ),
      ),
      (outcome) {
        switch (outcome) {
          case SubscriptionResult.success:
            emailController.clear();
            subscribeCommand.setData(
              "You're on the list! Check your inbox to confirm.",
            );
          case SubscriptionResult.alreadySubscribed:
            subscribeCommand.setData("You're already subscribed.");
        }
      },
    );
  }

  void dispose() {
    emailController.dispose();
    subscribeCommand.dispose();
  }
}

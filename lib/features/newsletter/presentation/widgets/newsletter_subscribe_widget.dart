import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/presentation/widgets/custom_text_field.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';

class NewsletterSubscribeWidget extends StatefulWidget {
  const NewsletterSubscribeWidget({
    required this.controller,
    super.key,
  });

  final NewsletterController controller;

  @override
  State<NewsletterSubscribeWidget> createState() =>
      _NewsletterSubscribeWidgetState();
}

class _NewsletterSubscribeWidgetState extends State<NewsletterSubscribeWidget> {
  late final NewsletterController _controller;
  bool _wasLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.subscribeCommand.addListener(_handleSubscribeFeedback);
  }

  @override
  void dispose() {
    _controller.subscribeCommand.removeListener(_handleSubscribeFeedback);
    super.dispose();
  }

  void _handleSubscribeFeedback() {
    if (!mounted) {
      return;
    }

    final command = _controller.subscribeCommand;
    final justFinished = _wasLoading && !command.isLoading;
    _wasLoading = command.isLoading;

    if (!justFinished) {
      return;
    }

    final feedback = command.error ?? command.data;
    if (feedback == null) {
      return;
    }

    final isError = command.error != null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedback),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CustomColor.primary.withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.markunread_mailbox_rounded,
                  color: CustomColor.primary,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Subscribe to the Newsletter',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: CustomColor.primary,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Get a short email when I publish a new post. '
              'No spam, unsubscribe any time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: CustomColor.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final emailField = CustomTextField(
                  hintText: 'you@example.com',
                  controller: _controller.emailController,
                  isEmail: true,
                  inputType: 'Email',
                );
                final subscribeButton = ListenableBuilder(
                  listenable: _controller.subscribeCommand,
                  builder: (context, _) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.1,
                        ),
                      ),
                      onPressed: _controller.subscribeCommand.isLoading
                          ? null
                          : _controller.subscribe,
                      icon: _controller.subscribeCommand.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 20),
                      label: Text(
                        _controller.subscribeCommand.isLoading
                            ? 'Subscribing...'
                            : 'Subscribe',
                      ),
                    );
                  },
                );

                if (constraints.maxWidth >= kMinDesktopWidth) {
                  return Row(
                    children: [
                      Expanded(child: emailField),
                      const SizedBox(width: 12),
                      subscribeButton,
                    ],
                  );
                }
                return Column(
                  children: [
                    emailField,
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: subscribeButton,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

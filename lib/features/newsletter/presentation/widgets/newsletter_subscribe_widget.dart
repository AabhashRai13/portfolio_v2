import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
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
    final theme = Theme.of(context);
    final palette = theme.blogPalette;
    final primary = theme.colorScheme.primary;

    return Form(
      key: _controller.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.borderSoft),
          boxShadow: [
            BoxShadow(
              color: palette.shadowColor,
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  color: primary,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Enjoyed this one?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: primary,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Get a short email when I publish a new post. '
              'No spam, unsubscribe any time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: palette.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final emailField = _NewsletterEmailField(
                  controller: _controller.emailController,
                );
                final subscribeButton = ListenableBuilder(
                  listenable: _controller.subscribeCommand,
                  builder: (context, _) {
                    final isLoading = _controller.subscribeCommand.isLoading;

                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
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
                      onPressed: isLoading ? null : _controller.subscribe,
                      icon: isLoading
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
                        isLoading ? 'Subscribing...' : 'Send me the next Blog',
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

class _NewsletterEmailField extends StatelessWidget {
  const _NewsletterEmailField({required this.controller});

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: palette.textStrong),
      validator: (value) {
        final email = value?.trim() ?? '';
        if (email.isEmpty) {
          return 'Please enter your email';
        }
        if (!_emailRegex.hasMatch(email)) {
          return 'Enter a valid email';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        fillColor: palette.surfaceSubtle,
        focusedBorder: _inputBorder,
        enabledBorder: _inputBorder,
        border: _inputBorder,
        errorBorder: _inputBorder,
        focusedErrorBorder: _inputBorder,
        hintText: 'you@example.com',
        hintStyle: TextStyle(color: palette.textMuted),
      ),
    );
  }

  OutlineInputBorder get _inputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );
  }
}

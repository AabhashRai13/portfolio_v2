import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/presentation/widgets/custom_text_field.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({
    required this.controller,
    super.key,
  });

  final ContactController controller;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late final ContactController _controller;
  String? _lastFeedback;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.submitCommand.addListener(_handleSubmitFeedback);
  }

  @override
  void dispose() {
    _controller.submitCommand.removeListener(_handleSubmitFeedback);
    super.dispose();
  }

  void _handleSubmitFeedback() {
    if (!mounted) {
      return;
    }

    final command = _controller.submitCommand;
    if (command.isLoading) {
      return;
    }

    final feedback = command.error ?? command.data;
    if (feedback == null || feedback == _lastFeedback) {
      return;
    }

    _lastFeedback = feedback;
    final isError = command.error != null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedback),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );

    _controller.resetSubmitFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Container(
        color: CustomColor.bgLight1,
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
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
                      Icons.mail_rounded,
                      color: CustomColor.primary,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Get In Touch',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: CustomColor.primary,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= kMinDesktopWidth) {
                      return Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                              hintText: 'Your name',
                              controller: _controller.nameController,
                              inputType: 'Name',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            child: CustomTextField(
                              hintText: 'Your email',
                              controller: _controller.emailController,
                              isEmail: true,
                              inputType: 'Email',
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        CustomTextField(
                          hintText: 'Your name',
                          controller: _controller.nameController,
                          inputType: 'Name',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: 'Your email',
                          inputType: 'Email',
                          controller: _controller.emailController,
                          isEmail: true,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  hintText: 'Your phone number',
                  inputType: 'Phone Number',
                  controller: _controller.phoneController,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  hintText: 'Your message',
                  inputType: 'Message',
                  maxLines: 8,
                  controller: _controller.messageController,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ListenableBuilder(
                    listenable: _controller.submitCommand,
                    builder: (context, _) {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.1,
                          ),
                        ),
                        onPressed: _controller.submitCommand.isLoading
                            ? null
                            : _controller.submit,
                        icon: _controller.submitCommand.isLoading
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
                          _controller.submitCommand.isLoading
                              ? 'Sending...'
                              : 'Send Message',
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 80,
                  height: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [CustomColor.primary, CustomColor.pastelRed],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _ContactIconButton(
                      icon: FontAwesomeIcons.github,
                      url: SnsLinks.github,
                      onTap: _controller.openSocialLink,
                    ),
                    _ContactIconButton(
                      icon: FontAwesomeIcons.linkedin,
                      url: SnsLinks.linkedIn,
                      onTap: _controller.openSocialLink,
                    ),
                    _ContactIconButton(
                      icon: FontAwesomeIcons.instagram,
                      url: SnsLinks.instagram,
                      onTap: _controller.openSocialLink,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactIconButton extends StatefulWidget {
  const _ContactIconButton({
    required this.icon,
    required this.url,
    required this.onTap,
  });

  final IconData icon;
  final String url;
  final Future<void> Function(String url) onTap;

  @override
  State<_ContactIconButton> createState() => _ContactIconButtonState();
}

class _ContactIconButtonState extends State<_ContactIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hovered
                ? CustomColor.primary.withValues(alpha: 0.12)
                : const Color(0xFFF7F8FA),
            shape: BoxShape.circle,
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: CustomColor.primary.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              color: CustomColor.primary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

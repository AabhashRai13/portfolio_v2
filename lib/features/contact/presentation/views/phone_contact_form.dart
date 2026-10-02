import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';
import 'package:my_portfolio/features/contact/presentation/widgets/contact_chat_header.dart';

/// The contact form sized for the landing phone's screen: a back header over
/// the shared form. Owns its controller, like the contact panel.
class PhoneContactForm extends StatefulWidget {
  const PhoneContactForm({required this.onClose, super.key});

  /// Restores the phone's widget grid.
  final VoidCallback onClose;

  @override
  State<PhoneContactForm> createState() => _PhoneContactFormState();
}

class _PhoneContactFormState extends State<PhoneContactForm> {
  late final ContactController _controller = getIt<ContactController>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
      },
      // Takes focus on open so Esc works before any field is focused.
      child: Focus(
        autofocus: true,
        // Own messenger + scaffold so the form's snackbars show inside the
        // phone. The page, not the phone, makes room for an on-screen
        // keyboard, so this scaffold must not shrink for it.
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: palette.sectionBackground,
            resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ContactChatHeader(onBack: widget.onClose),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ContactSection(controller: _controller),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

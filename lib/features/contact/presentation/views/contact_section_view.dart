import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/resources/fa_icons.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_topic.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';

/// The contact form, styled as a chat: a greeting bubble, topic chips, the
/// message, then where to reply. Message first, details second: once someone
/// has written, giving an email finishes a conversation instead of starting
/// paperwork. Hosts (the contact panel, the landing phone) provide the
/// header and the scrolling.
class ContactSection extends StatefulWidget {
  const ContactSection({required this.controller, super.key});

  final ContactController controller;

  static const Key messageFieldKey = ValueKey<String>('contact-message');
  static const Key nameFieldKey = ValueKey<String>('contact-name');
  static const Key emailFieldKey = ValueKey<String>('contact-email');

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late final ContactController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.submitCommand.addListener(_showSubmitError);
  }

  @override
  void dispose() {
    _controller.submitCommand.removeListener(_showSubmitError);
    super.dispose();
  }

  /// Success has its own state; only failures surface as a snackbar.
  void _showSubmitError() {
    if (!mounted) return;
    final command = _controller.submitCommand;
    final error = command.error;
    if (command.isLoading || error == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
    _controller.resetSubmitFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _controller.sentTo,
      builder: (context, sentTo, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: sentTo == null ? _form(context) : _sent(sentTo),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return Form(
      key: _controller.formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Bubble(text: 'Hey! What are you building?'),
            const SizedBox(height: 12),
            ValueListenableBuilder<ContactTopic?>(
              valueListenable: _controller.topic,
              builder: (context, selected, _) => Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final topic in ContactTopic.values)
                    _TopicChip(
                      topic: topic,
                      selected: topic == selected,
                      onSelected: () => _controller.toggleTopic(topic),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _ContactField(
              key: ContactSection.messageFieldKey,
              controller: _controller.messageController,
              label: 'Your message',
              hint: 'Tell me a bit about it…',
              minLines: 3,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  _isBlank(value) ? 'Tell me a little about it.' : null,
            ),
            const SizedBox(height: 20),
            Text(
              'WHERE CAN I REPLY?',
              style: SiteText.label(palette.textSecondary, size: 11),
            ),
            const SizedBox(height: 10),
            _ContactField(
              key: ContactSection.nameFieldKey,
              controller: _controller.nameController,
              label: 'Name',
              autofillHints: const [AutofillHints.name],
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  _isBlank(value) ? 'What should I call you?' : null,
            ),
            const SizedBox(height: 10),
            _ContactField(
              key: ContactSection.emailFieldKey,
              controller: _controller.emailController,
              label: 'Email',
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => unawaited(_controller.submit()),
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            _SendButton(
              command: _controller.submitCommand,
              onPressed: () => unawaited(_controller.submit()),
            ),
            const SizedBox(height: 20),
            _SocialRow(onTap: _controller.openSocialLink),
          ],
        ),
      ),
    );
  }

  Widget _sent(String email) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Bubble(text: "Got it. I'll reply to $email soon."),
        const SizedBox(height: 12),
        SiteTextLink(
          label: 'Send another message',
          onTap: _controller.startNewMessage,
        ),
      ],
    );
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;

  static final _emailPattern = RegExp(r'^[\w-\.+]+@([\w-]+\.)+[\w-]{2,}$');

  static String? _validateEmail(String? value) {
    if (_isBlank(value)) return 'I need this to reply.';
    if (!_emailPattern.hasMatch(value!.trim())) {
      return "That email doesn't look right.";
    }
    return null;
  }
}

/// A message from Aabhash, drawn like an incoming chat bubble.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              text,
              style: TextStyle(
                color: palette.textStrong,
                fontSize: 15,
                height: 1.35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.selected,
    required this.onSelected,
  });

  final ContactTopic topic;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return ChoiceChip(
      label: Text(topic.label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      shape: const StadiumBorder(),
      backgroundColor: palette.sectionBackground,
      selectedColor: palette.textStrong,
      side: BorderSide(
        color: selected
            ? palette.textStrong
            : palette.textSecondary.withValues(alpha: 0.4),
      ),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: selected ? palette.sectionBackground : palette.textStrong,
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  const _ContactField({
    required this.controller,
    required this.label,
    required this.validator,
    this.hint,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final String? hint;
  final int? minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final error = Theme.of(context).colorScheme.error;
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      // Errors appear once a field is left or on send, never on open.
      autovalidateMode: AutovalidateMode.onUnfocus,
      cursorColor: palette.textStrong,
      style: TextStyle(color: palette.textStrong, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: palette.textSecondary),
        floatingLabelStyle: TextStyle(color: palette.textStrong),
        hintStyle: TextStyle(
          color: palette.textSecondary.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: palette.surfaceCard,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: border(palette.primaryAccent.withValues(alpha: 0.35)),
        focusedBorder: border(palette.textStrong, 1.5),
        errorBorder: border(error),
        focusedErrorBorder: border(error, 1.5),
        errorStyle: TextStyle(color: error, fontSize: 12),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.command, required this.onPressed});

  final Command<String?> command;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return ListenableBuilder(
      listenable: command,
      builder: (context, _) {
        final loading = command.isLoading;
        return SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: loading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: palette.textStrong,
              foregroundColor: palette.sectionBackground,
              disabledBackgroundColor: palette.textStrong.withValues(
                alpha: 0.6,
              ),
              disabledForegroundColor: palette.sectionBackground,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    loading ? 'Sending…' : 'Send message',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (loading)
                  SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.sectionBackground,
                    ),
                  )
                else
                  const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.onTap});

  final Future<void> Function(String url) onTap;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    // The label sits above the icons so all three fit the phone's narrow
    // screen on one row.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'or find me on',
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            _ContactIconButton(
              icon: FaIcons.github,
              url: SnsLinks.github,
              label: 'GitHub',
              onTap: onTap,
            ),
            _ContactIconButton(
              icon: FaIcons.linkedin,
              url: SnsLinks.linkedIn,
              label: 'LinkedIn',
              onTap: onTap,
            ),
            _ContactIconButton(
              icon: FaIcons.instagram,
              url: SnsLinks.instagram,
              label: 'Instagram',
              onTap: onTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactIconButton extends StatefulWidget {
  const _ContactIconButton({
    required this.icon,
    required this.url,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String url;
  final String label;
  final Future<void> Function(String url) onTap;

  @override
  State<_ContactIconButton> createState() => _ContactIconButtonState();
}

class _ContactIconButtonState extends State<_ContactIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Semantics(
      link: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => unawaited(widget.onTap(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hovered
                  ? palette.primaryAccent.withValues(alpha: 0.12)
                  : palette.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FaIconData(widget.icon),
                color: palette.textStrong,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

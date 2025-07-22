import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_field.dart';
import 'package:my_portfolio/services/contact_services.dart';
import 'package:url_launcher/url_launcher.dart' as html;

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final ContactServices contactServices = ContactServices();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: contactServices.formKey,
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
                // Title with icon
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_rounded,
                        color: CustomColor.primary, size: 28,),
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
                // Name and email fields
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= kMinDesktopWidth) {
                      return Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                              hintText: 'Your name',
                              controller: contactServices.nameController,
                              inputType: 'Name',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            child: CustomTextField(
                              hintText: 'Your email',
                              controller: contactServices.emailController,
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
                          controller: contactServices.nameController,
                          inputType: 'Name',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: 'Your email',
                          inputType: 'Email',
                          controller: contactServices.emailController,
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
                  controller: contactServices.phoneController,
                ),
                const SizedBox(height: 18),
                // Message field
                CustomTextField(
                  hintText: 'Your message',
                  inputType: 'Message',
                  maxLines: 8,
                  controller: contactServices.messageController,
                ),
                const SizedBox(height: 24),
                // Send button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() => isLoading = true);
                            await contactServices.submitForm(context);
                            setState(() => isLoading = false);
                          },
                    icon: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                    label: isLoading
                        ? const Text('Sending...')
                        : const Text('Send Message'),
                  ),
                ),
                const SizedBox(height: 30),
                // Divider
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
                // Social icons
                const Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _ContactIconButton(
                      icon: FontAwesomeIcons.github,
                      url: SnsLinks.github,
                    ),
                    _ContactIconButton(
                      icon: FontAwesomeIcons.linkedin,
                      url: SnsLinks.linkedIn,
                    ),
                    _ContactIconButton(
                      icon: FontAwesomeIcons.instagram,
                      url: SnsLinks.instagram,
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
  const _ContactIconButton({required this.icon, required this.url});
  final IconData icon;
  final String url;

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
        onTap: () => html.launchUrl(Uri.parse(widget.url)),
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

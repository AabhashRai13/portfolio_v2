import 'package:flutter/material.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';

const double _panelWidth = 420;

/// Opens the contact form over the current page: a right-hand panel on
/// desktop, a bottom sheet below [kSiteDesktopBreakpoint]. Completes when it
/// closes.
Future<void> showContactPanel(BuildContext context) async {
  final isDesktop = MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;

  if (isDesktop) {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close contact',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, _, _) => const Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: _panelWidth,
          height: double.infinity,
          child: _ContactPanelBody(),
        ),
      ),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: child,
      ),
    );
  } else {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.92,
        child: _ContactPanelBody(),
      ),
    );
  }
}

/// Owns the form controller so it is disposed only once the route, including
/// its exit animation, has been removed from the tree.
class _ContactPanelBody extends StatefulWidget {
  const _ContactPanelBody();

  @override
  State<_ContactPanelBody> createState() => _ContactPanelBodyState();
}

class _ContactPanelBodyState extends State<_ContactPanelBody> {
  late final ContactController _controller = getIt<ContactController>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    // Own messenger + scaffold so the form's snackbars appear inside the
    // panel instead of behind the modal barrier. The scaffold also resizes
    // for the mobile keyboard.
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: palette.sectionBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'CONTACT',
                        style: SiteText.display(palette.textStrong, size: 44),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      icon: Icon(
                        Icons.close_rounded,
                        color: palette.textSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ContactSection(
                    controller: _controller,
                    embedded: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

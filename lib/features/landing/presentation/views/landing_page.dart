import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

/// Landing hub. Phase 1 is type and links only; Phase 2 adds the phone and
/// live widgets between the name and the tagline.
class LandingPage extends StatefulWidget {
  const LandingPage({this.openContactOnStart = false, super.key});

  /// True for `/contact`: open the contact panel over the landing on load.
  final bool openContactOnStart;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    if (widget.openContactOnStart) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_openContact()),
      );
    }
  }

  Future<void> _openContact() async {
    await showContactPanel(context);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            'SYDNEY, AUSTRALIA',
                            style: SiteText.label(palette.textSecondary),
                          ),
                          Text(
                            '·',
                            style: SiteText.label(palette.textSecondary),
                          ),
                          SiteTextLink(
                            label: SnsLinks.email,
                            onTap: () => unawaited(
                              openExternal('mailto:${SnsLinks.email}'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isDesktop ? 24 : 16),
                      Semantics(
                        header: true,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'AABHASH RAI',
                            style: SiteText.display(
                              palette.textStrong,
                              size: isDesktop ? 168 : 112,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 28 : 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Text(
                          'I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS',
                          textAlign: TextAlign.center,
                          style: SiteText.tagline(
                            palette.taglineText,
                            size: isDesktop ? 72 : 36,
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 40 : 28),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          for (final section in SiteSection.values)
                            SiteTextLink(
                              label: section.label,
                              onTap: () => openSiteSection(context, section),
                            ),
                          SiteTextLink(
                            label: 'Résumé',
                            onTap: () => unawaited(openResume()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: ThemeToggleButton(iconColor: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

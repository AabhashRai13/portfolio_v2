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
import 'package:my_portfolio/features/landing/presentation/widgets/landing_phone.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

/// Landing hub with four live Flutter previews: framed by a draggable phone
/// on desktop and rendered directly as a grid on mobile and tablet.
class LandingPage extends StatefulWidget {
  const LandingPage({this.openContactOnStart = false, super.key});

  /// True for `/contact`: open the contact panel over the landing on load.
  final bool openContactOnStart;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.openContactOnStart) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_openContact()),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _entranceController
        ..stop()
        ..value = 1;
    } else if (_entranceController.value == 0 &&
        !_entranceController.isAnimating) {
      _entranceController.forward();
    }
  }

  Future<void> _openContact() async {
    await showContactPanel(context);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;
    final motionEnabled = !MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: isDesktop ? 12 : 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (isDesktop ? 24 : 40),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LocationLine(palette: palette),
                          SizedBox(height: isDesktop ? 8 : 6),
                          _AnimatedWords(
                            text: 'AABHASH RAI',
                            animation: _entranceController,
                            style: SiteText.display(
                              palette.textStrong,
                              size: isDesktop ? 150 : 88,
                            ),
                            header: true,
                            fit: true,
                          ),
                          if (!isDesktop) ...[
                            const SizedBox(height: 8),
                            _Tagline(
                              animation: _entranceController,
                              palette: palette,
                              fontSize: 30,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 560,
                              height: MediaQuery.sizeOf(context).width < 500
                                  ? 254
                                  : 360,
                              child: LandingWidgetGrid(
                                entrance: _entranceController,
                                onOpen: (section) =>
                                    openSiteSection(context, section),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 8),
                            ScaleTransition(
                              scale: CurvedAnimation(
                                parent: _entranceController,
                                curve: const Interval(
                                  0.2,
                                  0.76,
                                  curve: Curves.elasticOut,
                                ),
                              ),
                              child: LandingPhone(
                                motionEnabled: motionEnabled,
                                child: LandingWidgetGrid(
                                  entrance: _entranceController,
                                  onOpen: (section) =>
                                      openSiteSection(context, section),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _Tagline(
                              animation: _entranceController,
                              palette: palette,
                              fontSize: 52,
                            ),
                          ],
                          SizedBox(height: isDesktop ? 10 : 12),
                          Text(
                            isDesktop
                                ? 'LIVE FLUTTER WIDGETS, NOT VIDEO. DRAG ONE.'
                                : 'LIVE FLUTTER WIDGETS, NOT VIDEO.',
                            textAlign: TextAlign.center,
                            style: SiteText.label(
                              palette.textSecondary,
                              size: 10,
                            ),
                          ),
                          _NavigationLinks(
                            onOpen: (section) =>
                                openSiteSection(context, section),
                          ),
                        ],
                      ),
                    ),
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

class _LocationLine extends StatelessWidget {
  const _LocationLine({required this.palette});

  final HomePalette palette;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(
          'SYDNEY, AUSTRALIA',
          style: SiteText.label(palette.textSecondary),
        ),
        Text('·', style: SiteText.label(palette.textSecondary)),
        SiteTextLink(
          label: SnsLinks.email,
          onTap: () => unawaited(openExternal('mailto:${SnsLinks.email}')),
        ),
      ],
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline({
    required this.animation,
    required this.palette,
    required this.fontSize,
  });

  static const text = 'I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS';

  final Animation<double> animation;
  final HomePalette palette;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: _AnimatedWords(
        text: text,
        animation: animation,
        style: SiteText.tagline(palette.taglineText, size: fontSize),
      ),
    );
  }
}

class _AnimatedWords extends StatelessWidget {
  const _AnimatedWords({
    required this.text,
    required this.animation,
    required this.style,
    this.header = false,
    this.fit = false,
  });

  final String text;
  final Animation<double> animation;
  final TextStyle style;
  final bool header;
  final bool fit;

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    final content = AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: (style.fontSize ?? 16) * 0.18,
        children: [
          for (var index = 0; index < words.length; index++)
            _word(words[index], index),
        ],
      ),
    );

    return Semantics(
      label: text,
      header: header,
      child: ExcludeSemantics(
        child: fit ? FittedBox(fit: BoxFit.scaleDown, child: content) : content,
      ),
    );
  }

  Widget _word(String word, int index) {
    final start = 0.02 + (index * 0.055);
    final end = (start + 0.5).clamp(0.0, 1.0);
    final value = Curves.elasticOut.transform(
      ((animation.value - start) / (end - start)).clamp(0.0, 1.0),
    );

    return Transform.translate(
      offset: Offset(0, 8 * (1 - value)),
      child: Transform.scale(
        alignment: Alignment.bottomCenter,
        scaleY: value,
        child: Text(word, style: style, textAlign: TextAlign.center),
      ),
    );
  }
}

class _NavigationLinks extends StatelessWidget {
  const _NavigationLinks({required this.onOpen});

  final ValueChanged<SiteSection> onOpen;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        for (final section in SiteSection.values)
          SiteTextLink(
            label: section.label,
            onTap: () => onOpen(section),
          ),
        SiteTextLink(
          label: 'Résumé',
          onTap: () => unawaited(openResume()),
        ),
      ],
    );
  }
}

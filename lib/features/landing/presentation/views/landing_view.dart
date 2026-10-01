import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_phone.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

/// Stateless renderer for the landing hub.
class LandingView extends StatelessWidget {
  const LandingView({
    required this.entrance,
    required this.phoneMotion,
    required this.onOpenWidget,
    required this.onOpenLink,
    super.key,
  });

  final Animation<double> entrance;
  final LandingPhoneMotionController phoneMotion;
  final LandingWidgetOpen onOpenWidget;
  final ValueChanged<SiteSection> onOpenLink;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewport = MediaQuery.sizeOf(context);
    final isDesktop = viewport.width >= kSiteDesktopBreakpoint;
    final isRoomyDesktop = viewport.width >= 1280;
    final metadataNameGap = isDesktop ? (isRoomyDesktop ? 32.0 : 24.0) : 14.0;
    // Reserve the enlarged phone's paint bounds without moving hover targets.
    final namePhoneGap = isRoomyDesktop ? 68.0 : 60.0;
    final phoneHeadlineGap = isRoomyDesktop ? 84.0 : 76.0;
    final headlineInstructionGap = isDesktop
        ? (isRoomyDesktop ? 24.0 : 18.0)
        : 20.0;
    final instructionNavigationGap = isDesktop
        ? (isRoomyDesktop ? 24.0 : 16.0)
        : 8.0;
    final glow = Color.lerp(
      palette.sectionBackground,
      palette.primaryAccent,
      isDark ? 0.13 : 0.14,
    )!;
    final edge = Color.alphaBlend(
      palette.shadowColor.withValues(alpha: isDark ? 0.48 : 0.08),
      palette.sectionBackground,
    );

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.18),
            radius: 1.02,
            colors: [glow, palette.sectionBackground, edge],
            stops: const [0, 0.6, 1],
          ),
        ),
        child: SafeArea(
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
                        constraints: const BoxConstraints(maxWidth: 1180),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScaleTransition(
                              scale: phoneMotion.textScale,
                              child: _LocationLine(palette: palette),
                            ),
                            SizedBox(height: metadataNameGap),
                            ScaleTransition(
                              scale: phoneMotion.textScale,
                              alignment: Alignment.topCenter,
                              child: _AnimatedWords(
                                text: 'AABHASH RAI',
                                animation: entrance,
                                style: SiteText.display(
                                  palette.textStrong,
                                  size: isDesktop ? 128 : 88,
                                ),
                                header: true,
                                fit: true,
                              ),
                            ),
                            if (!isDesktop) ...[
                              const SizedBox(height: 16),
                              _Tagline(
                                animation: entrance,
                                palette: palette,
                                fontSize: 30,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 560,
                                height: MediaQuery.sizeOf(context).width < 500
                                    ? 254
                                    : 360,
                                child: LandingWidgetGrid(
                                  entrance: entrance,
                                  onOpen: onOpenWidget,
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: namePhoneGap),
                              ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: entrance,
                                  curve: const Interval(
                                    0.2,
                                    0.76,
                                    curve: Curves.elasticOut,
                                  ),
                                ),
                                child: LandingPhone(
                                  motion: phoneMotion,
                                  child: LandingWidgetGrid(
                                    entrance: entrance,
                                    onOpen: onOpenWidget,
                                  ),
                                ),
                              ),
                              SizedBox(height: phoneHeadlineGap),
                              ScaleTransition(
                                scale: phoneMotion.textScale,
                                alignment: Alignment.bottomCenter,
                                child: _Tagline(
                                  animation: entrance,
                                  palette: palette,
                                  fontSize: 52,
                                ),
                              ),
                            ],
                            SizedBox(height: headlineInstructionGap),
                            ScaleTransition(
                              scale: phoneMotion.textScale,
                              child: Text(
                                'EXPLORE THE TILES',
                                textAlign: TextAlign.center,
                                style: SiteText.label(
                                  palette.textSecondary,
                                  size: 10,
                                ),
                              ),
                            ),
                            SizedBox(height: instructionNavigationGap),
                            ScaleTransition(
                              scale: phoneMotion.textScale,
                              child: _NavigationLinks(onOpen: onOpenLink),
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
          fontSize: 12,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _AnimatedWords(
          text: text,
          animation: animation,
          style: SiteText.tagline(
            palette.taglineText,
            size: fontSize,
          ).copyWith(height: 1.06),
        ),
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

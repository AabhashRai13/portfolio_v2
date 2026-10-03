import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_phone_stage.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

/// Stateless renderer for the landing hub.
class LandingView extends StatelessWidget {
  const LandingView({
    required this.entrance,
    required this.phoneMotion,
    required this.onOpenWidget,
    super.key,
  });

  final Animation<double> entrance;
  final LandingPhoneMotionController phoneMotion;
  final ValueChanged<SiteSection> onOpenWidget;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final viewport = MediaQuery.sizeOf(context);
    final isDesktop = viewport.width >= kSiteDesktopBreakpoint;
    final isRoomyDesktop = viewport.width >= 1280;
    // The phone keeps its size, so on shorter desktop viewports the name,
    // tagline and top gap shrink to keep the whole tagline on the first
    // screen. The tagline cap keeps it on one line.
    final nameSize = isDesktop
        ? (viewport.height * 0.1).clamp(80.0, 128.0)
        : 88.0;
    final taglineSize = (viewport.height * 0.038).clamp(30.0, 40.0);
    final metadataNameGap = isDesktop
        ? (viewport.height * 0.024).clamp(16.0, isRoomyDesktop ? 32.0 : 24.0)
        : 14.0;
    // Reserve the enlarged phone's paint bounds without moving hover targets.
    final namePhoneGap = isRoomyDesktop ? 68.0 : 60.0;
    final phoneHeadlineGap = isRoomyDesktop ? 84.0 : 76.0;
    final headlineInstructionGap = isDesktop
        ? (isRoomyDesktop ? 24.0 : 18.0)
        : 20.0;
    // Read above the Scaffold, which hides the inset from its body.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final hub = Column(
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
            style: SiteText.display(palette.textStrong, size: nameSize),
            header: true,
            fit: true,
          ),
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 16),
          _Tagline(animation: entrance, palette: palette, fontSize: 30),
          const SizedBox(height: 24),
          SizedBox(
            width: 560,
            height: viewport.width < 500 ? 254 : 360,
            child: LandingWidgetGrid(entrance: entrance, onOpen: onOpenWidget),
          ),
        ] else ...[
          SizedBox(height: namePhoneGap),
          ScaleTransition(
            scale: CurvedAnimation(
              parent: entrance,
              curve: const Interval(0.2, 0.76, curve: Curves.elasticOut),
            ),
            child: LandingPhoneStage(
              motion: phoneMotion,
              entrance: entrance,
              onOpenWidget: onOpenWidget,
            ),
          ),
          SizedBox(height: phoneHeadlineGap),
          ScaleTransition(
            scale: phoneMotion.textScale,
            alignment: Alignment.bottomCenter,
            child: _Tagline(
              animation: entrance,
              palette: palette,
              fontSize: taglineSize,
            ),
          ),
        ],
        SizedBox(height: headlineInstructionGap),
        ScaleTransition(
          scale: phoneMotion.textScale,
          child: Text(
            'EXPLORE THE TILES',
            textAlign: TextAlign.center,
            style: SiteText.label(palette.textSecondary, size: 10),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2,
            colors: palette.heroGradient,
            stops: const [0.1, 0.4, 0.7, 1],
          ),
        ),
        child: SafeArea(
          minimum: EdgeInsets.all(isDesktop ? 24 : 10),
          child: _GlassPanel(
            palette: palette,
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isDesktop) {
                      // Short windows scale the whole hub down so it fits the
                      // first screen. The fit ignores an on-screen keyboard,
                      // so the phone's contact form scrolls instead of
                      // shrinking while someone types.
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: math.max(
                            0,
                            constraints.maxHeight + keyboardInset - 24,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: math.min(
                                  1180,
                                  constraints.maxWidth - 64,
                                ),
                              ),
                              child: hub,
                            ),
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 40,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1180),
                            child: hub,
                          ),
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }
}

/// Frosted panel that frames the whole landing over the hero gradient.
///
/// No BackdropFilter: only a smooth gradient sits behind the panel, so a blur
/// would look the same while re-blurring the screen on every phone frame.
class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.palette, required this.child});

  final HomePalette palette;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.glassFill,
        borderRadius: radius,
        border: Border.all(color: palette.glassBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor.withValues(alpha: 0.02),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.glassHighlightStrong, palette.glassHighlightSoft],
          ),
        ),
        child: SizedBox.expand(child: child),
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
      constraints: const BoxConstraints(maxWidth: 1000),
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

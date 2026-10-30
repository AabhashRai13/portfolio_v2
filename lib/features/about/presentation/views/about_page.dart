import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/breakpoints.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/about/data/about_content.dart';
import 'package:my_portfolio/features/about/presentation/widgets/intro_video.dart';
import 'package:my_portfolio/features/about/presentation/widgets/roll_text.dart';
import 'package:my_portfolio/features/about/presentation/widgets/scroll_highlight_text.dart';
import 'package:my_portfolio/features/about/presentation/widgets/scroll_reveal.dart';
import 'package:my_portfolio/features/about/presentation/widgets/sydney_clock.dart';

/// The video is the hero. The rest frames it for founders and hiring teams,
/// qualifies who is a good fit, and ends on one big contact button.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String ctaLabel = "TELL ME WHAT YOU'RE BUILDING";

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = MediaQuery.sizeOf(context).width < Breakpoints.smallTablet;
    final sectionGap = SizedBox(height: isNarrow ? 64 : 96);
    final meta = SiteText.label(palette.textSecondary);
    final strong = TextStyle(
      fontWeight: FontWeight.w600,
      color: palette.textStrong,
    );

    return SitePage(
      title: 'About',
      section: SiteSection.about,
      contentMaxWidth: 880,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Narrower than the copy so the video stays the hero without
          // swallowing the first screen; phones clamp it to full width.
          const Center(child: SizedBox(width: 640, child: IntroVideo())),
          SizedBox(height: isNarrow ? 32 : 48),
          for (final (index, line) in aboutStatement.indexed) ...[
            if (index > 0) SizedBox(height: isNarrow ? 20 : 28),
            ScrollHighlightText(
              line,
              style: strong.copyWith(
                fontSize: isNarrow ? 28 : 44,
                height: 1.15,
                letterSpacing: isNarrow ? -0.3 : -0.8,
              ),
            ),
          ],
          const SizedBox(height: 32),
          SydneyClock(style: meta),
          const SizedBox(height: 10),
          Row(
            children: [
              // Status-light green reads as "online" in both themes.
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _onlineGreen,
                  boxShadow: [
                    BoxShadow(
                      color: _onlineGreen.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(availability.toUpperCase(), style: meta),
              ),
            ],
          ),
          sectionGap,
          _Heading('Skills', isNarrow: isNarrow),
          // One trigger for the grid; the tiles ripple in reading order.
          ScrollReveal(
            duration: const Duration(milliseconds: 1000),
            builder: (context, reveal) => _Grid(
              columns: isNarrow ? 3 : 6,
              spacing: 12,
              children: [
                for (final (index, skill) in skills.indexed)
                  FadeUp(
                    reveal: staggered(
                      reveal,
                      index: index,
                      count: skills.length,
                    ),
                    rise: 16,
                    child: _SkillTile(skill),
                  ),
              ],
            ),
          ),
          sectionGap,
          _Heading('How I work', isNarrow: isNarrow),
          // The steps arrive 01, 02, 03, so the order reads as a process.
          ScrollReveal(
            duration: const Duration(milliseconds: 900),
            builder: (context, reveal) => _Grid(
              columns: isNarrow ? 1 : 3,
              spacing: isNarrow ? 24 : 32,
              children: [
                for (final (index, step) in howIWork.indexed)
                  FadeUp(
                    reveal: staggered(
                      reveal,
                      index: index,
                      count: howIWork.length,
                      span: 0.6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0${index + 1}  ${step.title.toUpperCase()}',
                          style: SiteText.label(palette.primaryAccent),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.body,
                          style: SiteText.body(palette.textStrong),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          sectionGap,
          _Heading("You'll be a good fit if you…", isNarrow: isNarrow),
          for (final (index, item) in goodFit.indexed)
            _FitRow(
              isNarrow: isNarrow,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: isNarrow ? 40 : 64,
                    child: Text(
                      '0${index + 1}',
                      style: SiteText.label(palette.primaryAccent),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: strong.copyWith(
                        fontSize: isNarrow ? 19 : 26,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          sectionGap,
          _Heading('Sound like you?', isNarrow: isNarrow),
          _ContactButton(isNarrow: isNarrow),
          const SizedBox(height: 16),
          Center(
            child: Text(
              replyPromise.toUpperCase(),
              textAlign: TextAlign.center,
              style: meta,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: SiteTextLink(
              label: 'Or grab my résumé (PDF) ↓',
              onTap: () => unawaited(openResume()),
            ),
          ),
        ],
      ),
    );
  }
}

const Color _onlineGreen = Color(0xFF22C55E);

class _Heading extends StatelessWidget {
  const _Heading(this.text, {required this.isNarrow});

  final String text;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: ScrollReveal(
        builder: (context, reveal) => FadeUp(
          reveal: reveal,
          child: Semantics(
            header: true,
            child: Text(
              text.toUpperCase(),
              style: SiteText.display(
                palette.textStrong,
                size: isNarrow ? 36 : 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A good-fit row whose divider draws in left to right before the line
/// rises in under it, like ticking off a checklist.
class _FitRow extends StatelessWidget {
  const _FitRow({required this.isNarrow, required this.child});

  final bool isNarrow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return ScrollReveal(
      duration: const Duration(milliseconds: 800),
      builder: (context, reveal) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MatrixTransition(
            animation: reveal.drive(
              CurveTween(
                curve: const Interval(0, 0.6, curve: Curves.easeInOutCubic),
              ),
            ),
            alignment: Alignment.centerLeft,
            onTransform: (t) => Matrix4.diagonal3Values(t, 1, 1),
            child: ColoredBox(
              color: palette.primaryAccent.withValues(alpha: 0.3),
              child: const SizedBox(height: 1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isNarrow ? 16 : 22),
            child: FadeUp(
              reveal: reveal.drive(CurveTween(curve: const Interval(0.3, 1))),
              rise: 16,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// The page's one call to action. It settles into place as it arrives, then
/// its arrow slides in to point the way; its letters roll while it is
/// hovered or focused.
class _ContactButton extends StatefulWidget {
  const _ContactButton({required this.isNarrow});

  final bool isNarrow;

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = widget.isNarrow;
    return ScrollReveal(
      duration: const Duration(milliseconds: 700),
      builder: (context, reveal) {
        final settle = reveal.drive(CurveTween(curve: Curves.easeOutCubic));
        final arrow = reveal.drive(
          CurveTween(
            curve: const Interval(0.45, 1, curve: Curves.easeOutCubic),
          ),
        );
        return ClippedFade(
          opacity: settle,
          child: ScaleTransition(
            scale: settle.drive(Tween(begin: 0.96, end: 1)),
            child: SizedBox(
              width: double.infinity,
              height: isNarrow ? 68 : 96,
              child: FilledButton(
                onPressed: () => openSiteSection(context, SiteSection.contact),
                onHover: (hovered) => setState(() => _hovered = hovered),
                onFocusChange: (focused) => setState(() => _focused = focused),
                style: FilledButton.styleFrom(
                  backgroundColor: palette.textStrong,
                  foregroundColor: palette.sectionBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RollText(
                        AboutPage.ctaLabel,
                        active: _hovered || _focused,
                        style: SiteText.display(
                          palette.sectionBackground,
                          size: isNarrow ? 26 : 44,
                        ),
                      ),
                      SizedBox(width: isNarrow ? 10 : 16),
                      MatrixTransition(
                        animation: arrow,
                        onTransform: (t) =>
                            Matrix4.translationValues((t - 1) * 24, 0, 0),
                        child: ClippedFade(
                          opacity: arrow,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: isNarrow ? 26 : 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Equal-width columns that wrap, so rows stay aligned at any width.
class _Grid extends StatelessWidget {
  const _Grid({
    required this.columns,
    required this.spacing,
    required this.children,
  });

  final int columns;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile(this.skill);

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    const iconSize = 30.0;
    final icon = skill.icon;

    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: palette.primaryAccent.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            FaIcon(FaIconData(icon), size: iconSize, color: palette.textStrong)
          else
            Image.asset(
              skill.asset!,
              width: iconSize,
              height: iconSize,
              color: palette.textStrong,
            ),
          const SizedBox(height: 12),
          Text(
            skill.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: SiteText.body(
              palette.textSecondary,
              size: 14,
            ).copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}

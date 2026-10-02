import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/about/data/about_content.dart';
import 'package:my_portfolio/features/about/presentation/widgets/intro_video.dart';
import 'package:my_portfolio/features/about/presentation/widgets/sydney_clock.dart';

/// The video is the hero. The rest frames it for founders and hiring teams,
/// qualifies who is a good fit, and ends on one big contact button.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String ctaLabel = "TELL ME WHAT YOU'RE BUILDING";

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = MediaQuery.sizeOf(context).width < 600;
    final sectionGap = SizedBox(height: isNarrow ? 64 : 96);
    final meta = SiteText.label(palette.textSecondary);
    final strong = TextStyle(
      fontWeight: FontWeight.w600,
      color: palette.textStrong,
    );

    return SitePage(
      title: 'About',
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
            Text(
              line,
              style: strong.copyWith(
                fontSize: isNarrow ? 28 : 44,
                height: 1.15,
                letterSpacing: isNarrow ? -0.3 : -0.8,
              ),
            ),
          ],
          const SizedBox(height: 32),
          Wrap(
            spacing: 32,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SydneyClock(style: meta),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: palette.primaryAccent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(availability.toUpperCase(), style: meta),
                  ),
                ],
              ),
              Text(nowBuilding.toUpperCase(), style: meta),
            ],
          ),
          sectionGap,
          _Heading('Skills', isNarrow: isNarrow),
          _Grid(
            columns: isNarrow ? 3 : 6,
            spacing: 12,
            children: [for (final skill in skills) _SkillTile(skill)],
          ),
          sectionGap,
          _Heading('How I work', isNarrow: isNarrow),
          _Grid(
            columns: isNarrow ? 1 : 3,
            spacing: isNarrow ? 24 : 32,
            children: [
              for (final (index, step) in howIWork.indexed)
                Column(
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
            ],
          ),
          sectionGap,
          _Heading("You'll be a good fit if you…", isNarrow: isNarrow),
          for (final (index, item) in goodFit.indexed)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isNarrow ? 16 : 22),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: palette.primaryAccent.withValues(alpha: 0.3),
                  ),
                ),
              ),
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
          SizedBox(
            width: double.infinity,
            height: isNarrow ? 68 : 96,
            child: FilledButton(
              onPressed: () => openSiteSection(context, SiteSection.contact),
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
                    Text(
                      ctaLabel,
                      style: SiteText.display(
                        palette.sectionBackground,
                        size: isNarrow ? 26 : 44,
                      ),
                    ),
                    SizedBox(width: isNarrow ? 10 : 16),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: isNarrow ? 26 : 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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

class _Heading extends StatelessWidget {
  const _Heading(this.text, {required this.isNarrow});

  final String text;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Semantics(
        header: true,
        child: Text(
          text.toUpperCase(),
          style: SiteText.display(palette.textStrong, size: isNarrow ? 36 : 48),
        ),
      ),
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

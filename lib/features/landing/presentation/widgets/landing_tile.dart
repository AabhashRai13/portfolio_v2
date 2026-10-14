import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_tile_preview.dart';

class LandingTile extends StatelessWidget {
  const LandingTile({
    required this.section,
    required this.active,
    required this.focused,
    required this.onHover,
    required this.onFocusChange,
    required this.onTap,
    super.key,
  });

  final SiteSection section;
  final bool active;
  final bool focused;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onFocusChange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colors(context, section);

    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: 'Open ${section.label}',
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: focused
                  ? foreground.withValues(alpha: 0.85)
                  : Colors.transparent,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: background,
              child: InkWell(
                onTap: onTap,
                onHover: onHover,
                onFocusChange: onFocusChange,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ExcludeSemantics(
                      child: LandingTilePreview(
                        section: section,
                        foreground: foreground,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 10,
                      child: Text(
                        section.label.toUpperCase(),
                        style: SiteText.label(foreground, size: 11),
                      ),
                    ),
                    if (active)
                      Positioned(
                        right: 10,
                        bottom: 8,
                        child: Text(
                          'OPEN →',
                          style: SiteText.label(foreground, size: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _colors(BuildContext context, SiteSection section) {
    final palette = Theme.of(context).homePalette;
    return switch (section) {
      SiteSection.work => (palette.secondaryAccent, palette.textStrong),
      SiteSection.about => (palette.textStrong, palette.mediaForeground),
      SiteSection.writing => (palette.textStrong, palette.sectionBackground),
      SiteSection.contact => (
        palette.primaryAccent,
        Theme.of(context).brightness == Brightness.dark
            ? palette.sectionBackground
            : palette.textStrong,
      ),
    };
  }
}

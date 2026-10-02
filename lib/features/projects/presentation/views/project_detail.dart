import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_carousel.dart';

/// Opens [project] over the page. The poster grows out of [origin] (the
/// tapped card's global rect) into a panel, the details fade in after it,
/// and closing plays the same thing backwards. Esc, a tap outside or the
/// close button dismisses it. Completes when it closes.
Future<void> showProjectDetail(
  BuildContext context, {
  required ProjectSummary project,
  required Rect origin,
  required VoidCallback onOpenStore,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close ${project.title}',
    barrierColor: Colors.black54,
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 450),
    // The page animates its own parts; skip the default whole-page fade.
    transitionBuilder: (context, animation, _, child) => child,
    pageBuilder: (context, animation, _) => _ProjectDetail(
      project: project,
      origin: origin,
      animation: animation,
      onOpenStore: onOpenStore,
    ),
  );
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({
    required this.project,
    required this.origin,
    required this.animation,
    required this.onOpenStore,
  });

  final ProjectSummary project;
  final Rect origin;
  final Animation<double> animation;
  final VoidCallback onOpenStore;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final size = MediaQuery.sizeOf(context);
    final safe = MediaQuery.paddingOf(context);
    final isNarrow = size.width < 720;
    const inset = 20.0;

    // Final layout: full screen on phones, a centred panel elsewhere.
    final panel = isNarrow
        ? Offset.zero & size
        : Rect.fromCenter(
            center: size.center(Offset.zero),
            width: math.min(880, size.width - 64),
            height: math.min(860, size.height - 64),
          );
    final posterSpace = panel.width - inset * 2;
    final posterHeight = math.min(
      posterSpace / (isNarrow ? 1.6 : 1.9),
      panel.height * 0.5,
    );
    final posterWidth = posterHeight * (isNarrow ? 1.6 : 1.9);
    final poster = Rect.fromLTWH(
      panel.left + (panel.width - posterWidth) / 2,
      panel.top + inset + (isNarrow ? safe.top : 0),
      posterWidth,
      posterHeight,
    );
    final details = Rect.fromLTRB(
      panel.left + inset,
      poster.bottom + 24,
      panel.right - inset,
      panel.bottom - (isNarrow ? safe.bottom : inset),
    );

    final move = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    final reveal = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.55, 1, curve: Curves.easeOut),
    );

    // Transparent material: the links and buttons need one for their ink.
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = move.value;
          return Stack(
            children: [
              // The card's surface grows with the poster, then turns solid.
              Positioned.fromRect(
                rect: Rect.lerp(origin, panel, t)!,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.sectionBackground.withValues(
                      alpha: (t * 2).clamp(0.0, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(
                      lerpDouble(20, isNarrow ? 0 : 24, t)!,
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: Rect.lerp(origin, poster, t)!,
                child: ProjectPoster(project: project),
              ),
              Positioned.fromRect(
                rect: details,
                child: Opacity(
                  opacity: reveal.value,
                  child: Transform.translate(
                    offset: Offset(0, 16 * (1 - reveal.value)),
                    child: SingleChildScrollView(
                      child: _Details(
                        project: project,
                        isNarrow: isNarrow,
                        onOpenStore: onOpenStore,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: poster.top + 10,
                right: size.width - poster.right + 10,
                child: Opacity(
                  opacity: reveal.value,
                  child: PressScale(
                    child: IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        tapFeedback();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor: palette.textStrong,
                        backgroundColor: palette.surfaceCard.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _storeName(ProjectSummary project) =>
    project.link.contains('play.google.com') ? 'Google Play' : 'the App Store';

/// Two type styles only (display for the name, body for the rest) so the
/// eye keeps one rhythm; numbers in the result are bold so the proof leads.
class _Details extends StatelessWidget {
  const _Details({
    required this.project,
    required this.isNarrow,
    required this.onOpenStore,
  });

  final ProjectSummary project;
  final bool isNarrow;
  final VoidCallback onOpenStore;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final body = SiteText.body(palette.textStrong);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              project.title.toUpperCase(),
              style: SiteText.display(
                palette.textStrong,
                size: isNarrow ? 44 : 56,
              ),
            ),
          ),
          if (project.role != null) ...[
            const SizedBox(height: 8),
            Text(
              project.role!,
              style: SiteText.body(palette.textSecondary, size: 15),
            ),
          ],
          const SizedBox(height: 20),
          Text(project.summary, style: body),
          if (project.result != null) ...[
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                style: body,
                children: [
                  for (final word in project.result!.split(' '))
                    TextSpan(
                      text: '$word ',
                      style: word.startsWith(RegExp('[0-9]'))
                          ? const TextStyle(fontWeight: FontWeight.w700)
                          : null,
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          // SiteTextLink pads itself for its focus ring; pull it back so its
          // text lines up with the copy above.
          Transform.translate(
            offset: const Offset(-6, 0),
            child: SiteTextLink(
              label: 'View on ${_storeName(project)} ↗',
              onTap: onOpenStore,
            ),
          ),
        ],
      ),
    );
  }
}
